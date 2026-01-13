#requires -Version 5.1

[CmdletBinding()]
param()

${script:LogDir} = Join-Path $PSScriptRoot '..\logs'
${script:BackupDir} = Join-Path $PSScriptRoot '..\backup'
$newDirs = @(${script:LogDir}, ${script:BackupDir})
foreach ($d in $newDirs) { if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d | Out-Null } }
${script:LogPath} = Join-Path ${script:LogDir} ("setup-" + (Get-Date -Format 'yyyyMMdd-HHmmss') + ".log")

function Write-Log {
<#
.SYNOPSIS
Escreve entrada no log persistente.
.DESCRIPTION
Adiciona mensagem ao arquivo de log com timestamp e nível.
.PARAMETER Message
Texto da mensagem.
.PARAMETER Level
Nível da mensagem (Info, Warn, Error, Debug).
.EXAMPLE
Write-Log -Message "Instalando Chrome" -Level Info
#>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)] [string]$Message,
        [ValidateSet('Info','Warn','Error','Debug')] [string]$Level = 'Info'
    )
    $ts = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    $line = "[$ts] [$Level] $Message"
    Add-Content -Path ${script:LogPath} -Value $line
}

function Assert-Admin {
<#
.SYNOPSIS
Garante execução com privilégios administrativos.
.DESCRIPTION
Verifica e relança o script com RunAs se não estiver em modo administrador.
.EXAMPLE
Assert-Admin
#>
    [CmdletBinding()] param()
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
    if (-not $isAdmin) {
        Write-Log -Message 'Necessário executar como Administrador.' -Level Error
        throw 'Este script precisa ser executado como administrador.'
    }
}

function Ensure-Connectivity {
<#
.SYNOPSIS
Verifica conectividade de rede antes de downloads.
.PARAMETER Host
Host para teste (default: github.com).
.EXAMPLE
Ensure-Connectivity -Host 'github.com'
#>
    [CmdletBinding()] param([string]$Host = 'github.com')
    try {
        $ok = Test-Connection -ComputerName $Host -Count 1 -Quiet -ErrorAction Stop
        if (-not $ok) { throw "Sem conectividade para $Host" }
        Write-Log -Message "Conectividade OK: $Host" -Level Info
        return $true
    } catch {
        Write-Log -Message "Falha de conectividade: $Host. $_" -Level Error
        return $false
    }
}

function Ensure-Winget {
<#
.SYNOPSIS
Valida presença do winget e atualiza fontes.
.EXAMPLE
Ensure-Winget
#>
    [CmdletBinding()] param()
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Log -Message 'Winget não está instalado/App Installer desatualizado.' -Level Error
        throw 'Winget não está instalado. Atualize o App Installer (Windows 10 1809+).'
    }
    Write-Host 'Atualizando fontes do Winget...' -ForegroundColor Cyan
    winget source update
    if ($LASTEXITCODE -ne 0) {
        Write-Log -Message 'Falha ao atualizar fontes do winget.' -Level Warn
    } else {
        Write-Log -Message 'Fontes do winget atualizadas.' -Level Info
    }
}

function Get-WingetPackageInstalled {
<#
.SYNOPSIS
Verifica se um pacote winget já está instalado.
.PARAMETER Id
Identificador do pacote (ex.: Google.Chrome).
.EXAMPLE
Get-WingetPackageInstalled -Id 'Google.Chrome'
#>
    [CmdletBinding()] param([Parameter(Mandatory)] [string]$Id)
    $result = winget list --id $Id --accept-source-agreements | Out-String
    return ($result -match $Id)
}

function Install-WingetPackage {
<#
.SYNOPSIS
Instala pacote via winget de forma idempotente.
.DESCRIPTION
Usa SupportsShouldProcess, valida instalação existente e códigos de saída.
.PARAMETER Id
PackageId do winget.
.PARAMETER Name
Nome amigável para feedback.
.PARAMETER AdditionalArgs
Argumentos extras para winget install.
.EXAMPLE
Install-WingetPackage -Id 'Google.Chrome' -Name 'Google Chrome'
#>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory)] [string]$Id,
        [string]$Name = $Id,
        [string]$AdditionalArgs = ''
    )
    if (Get-WingetPackageInstalled -Id $Id) {
        Write-Host "$Name já instalado." -ForegroundColor Yellow
        Write-Log -Message "$Name já instalado (idempotente)." -Level Info
        return
    }
    if ($PSCmdlet.ShouldProcess($Name, 'Instalar via winget')) {
        Write-Host "Instalando $Name..." -ForegroundColor Magenta
        try {
            $cmd = "winget install --id $Id --silent --accept-package-agreements --accept-source-agreements $AdditionalArgs"
            iex $cmd
            if ($LASTEXITCODE -eq 0) {
                Write-Host "$Name instalado com sucesso!" -ForegroundColor Green
                Write-Log -Message "$Name instalado com sucesso." -Level Info
            } else {
                Write-Host "Erro ao instalar $Name (exit=$LASTEXITCODE)." -ForegroundColor Red
                Write-Log -Message "Erro ao instalar $Name (exit=$LASTEXITCODE)." -Level Error
                throw "Falha na instalação de $Name"
            }
        } catch {
            Write-Log -Message "Exceção ao instalar $($Name): $_" -Level Error
            throw
        }
    }
}

function Backup-RegistryPersonalize {
<#
.SYNOPSIS
Cria backup do registro de personalização do Windows.
.EXAMPLE
Backup-RegistryPersonalize
#>
    [CmdletBinding()] param()
    $backupPath = Join-Path ${script:BackupDir} ("registry-" + (Get-Date -Format 'yyyyMMdd-HHmmss') + ".reg")
    & reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" "$backupPath" | Out-Null
    Write-Log -Message "Backup do registro em $backupPath" -Level Info
    return $backupPath
}

function Invoke-ValidatedDownload {
<#
.SYNOPSIS
Download com validação de hash (SHA256).
.PARAMETER Uri
URL do recurso.
.PARAMETER OutputPath
Arquivo de destino.
.PARAMETER ExpectedSha256
Hash esperado (SHA256). Obrigatório.
.EXAMPLE
Invoke-ValidatedDownload -Uri 'https://example/file.zip' -OutputPath 'C:\tmp\file.zip' -ExpectedSha256 'ABC123...'
#>
    [CmdletBinding()] param(
        [Parameter(Mandatory)] [string]$Uri,
        [Parameter(Mandatory)] [string]$OutputPath,
        [Parameter(Mandatory)] [string]$ExpectedSha256
    )
    if (-not (Ensure-Connectivity)) { throw 'Sem conectividade para download.' }
    Invoke-WebRequest -Uri $Uri -OutFile $OutputPath -UseBasicParsing
    $hash = (Get-FileHash -Algorithm SHA256 -Path $OutputPath).Hash.ToLower()
    if ($hash -ne $ExpectedSha256.ToLower()) {
        Remove-Item -Path $OutputPath -Force -ErrorAction SilentlyContinue
        Write-Log -Message "Hash inválido para $OutputPath (esperado=$ExpectedSha256, obtido=$hash)." -Level Error
        throw 'Validação de hash falhou.'
    }
    Write-Log -Message "Download validado: $OutputPath" -Level Info
    return $true
}

function Set-AccentPinkTheme {
<#
.SYNOPSIS
Aplica tema claro e cor de destaque rosa com backup.
.EXAMPLE
Set-AccentPinkTheme
#>
    [CmdletBinding(SupportsShouldProcess=$true)] param()
    $bk = Backup-RegistryPersonalize
    if ($PSCmdlet.ShouldProcess('Tema do Windows', 'Aplicar tema rosa')) {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Value 1
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1
        # DWM AccentColor é DWORD BGR. Rosa (RGB 255, 105, 180) => BGR 180,105,255 => 0xB469FF
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "AccentColor" -Value 0x00B469FF
        Write-Log -Message 'Tema rosa aplicado.' -Level Info
    }
}

Export-ModuleMember -Function *
