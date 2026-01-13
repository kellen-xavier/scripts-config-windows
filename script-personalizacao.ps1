<#
.SYNOPSIS
Personaliza o Windows com segurança.
.DESCRIPTION
Remove atalhos .lnk, define papel de parede, aplica tema rosa, e executa Win11Debloat com validação de hash. Suporta -WhatIf/-Confirm.
.PARAMETER DebloatZipSha256
SHA256 esperado do arquivo ZIP do Win11Debloat.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter()] [string]$DebloatZipSha256
)

Import-Module -Force "$PSScriptRoot\modules\WinSetup.psm1"

try {
    Assert-Admin
    Write-Log -Message 'Início da personalização.' -Level Info

    # Remove atalhos .lnk da área de trabalho
    $desktop = Join-Path $env:USERPROFILE 'Desktop'
    $shortcuts = Get-ChildItem -Path $desktop -Filter *.lnk -ErrorAction SilentlyContinue
    if ($shortcuts) {
        foreach ($s in $shortcuts) {
            if ($PSCmdlet.ShouldProcess($s.FullName, 'Remover atalho')) {
                Remove-Item $s.FullName -Force
            }
        }
        Write-Host 'Atalhos removidos.' -ForegroundColor Green
    }

    # Papel de parede
    $wallpaperPath = "$PSScriptRoot\wallpaper\wallpaper-cute.jpg"
    if (Test-Path $wallpaperPath) {
        Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
        if ($PSCmdlet.ShouldProcess($wallpaperPath, 'Definir papel de parede')) {
            [Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 0x01 -bor 0x02) | Out-Null
            Write-Host "Papel de parede alterado para $wallpaperPath." -ForegroundColor Green
        }
    } else {
        Write-Host "Arquivo de papel de parede não encontrado: $wallpaperPath" -ForegroundColor Yellow
    }

    # Tema rosa com backup
    Set-AccentPinkTheme -WhatIf:$WhatIfPreference -Confirm:$ConfirmPreference

    # Definir Chrome como navegador padrão (se instalado)
    if (Get-WingetPackageInstalled -Id 'Google.Chrome') {
        try {
            if ($PSCmdlet.ShouldProcess('Google Chrome', 'Definir como navegador padrão')) {
                Start-Process -FilePath 'chrome.exe' -ArgumentList '--make-default-browser' -Wait -NoNewWindow
                Write-Host 'Chrome definido como navegador padrão.' -ForegroundColor Green
            }
        } catch {
            Write-Log -Message "Falha ao definir Chrome padrão: $_" -Level Warn
            Write-Host 'Não foi possível definir o Chrome como padrão automaticamente.' -ForegroundColor Yellow
        }
    } else {
        Write-Host 'Chrome não está instalado.' -ForegroundColor Yellow
    }

    # Win11Debloat com validação
    if ($DebloatZipSha256) {
        Ensure-Connectivity | Out-Null
        $zip = Join-Path $PSScriptRoot 'Win11Debloat.zip'
        $dest = Join-Path $PSScriptRoot 'Win11Debloat'
        $uri = 'https://github.com/Raphire/Win11Debloat/archive/refs/heads/main.zip'
        if ($PSCmdlet.ShouldProcess($uri, 'Baixar e validar Win11Debloat')) {
            Invoke-ValidatedDownload -Uri $uri -OutputPath $zip -ExpectedSha256 $DebloatZipSha256
            Expand-Archive -Path $zip -DestinationPath $dest -Force
            $scriptPath = Join-Path $dest 'Win11Debloat-main\Win11Debloat.ps1'
            Start-Process -FilePath 'powershell.exe' -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs -Wait
            Write-Host 'Win11Debloat executado.' -ForegroundColor Green
        }
    } else {
        Write-Host 'Hash SHA256 do Win11Debloat não fornecido. Pular execução por segurança.' -ForegroundColor Yellow
    }

    Write-Log -Message 'Personalização concluída.' -Level Info
} catch {
    Write-Log -Message "Falha geral na personalização: $_" -Level Error
    Write-Error $_
    exit 1
}
