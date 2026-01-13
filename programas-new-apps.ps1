<#
.SYNOPSIS
Instala aplicativos comuns de forma segura e idempotente via winget.
.DESCRIPTION
Verifica pré-requisitos, suporta -WhatIf/-Confirm, gera logs persistentes e falha com segurança.
.PARAMETER Apps
Lista personalizada de PackageIds para instalar (opcional).
.EXAMPLE
.\programas-new-apps.ps1 -WhatIf
#>

[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
param(
    [string[]]$Apps
)

Import-Module -Force "$PSScriptRoot\modules\WinSetup.psm1"

try {
    Assert-Admin
    Ensure-Winget
    Write-Log -Message 'Início da instalação de aplicativos.' -Level Info

    $defaultApps = @(
        @{Name='Google Chrome'; Id='Google.Chrome'},
        @{Name='Firefox'; Id='Mozilla.Firefox'},
        @{Name='Opera'; Id='Opera.Opera'},
        @{Name='VS Code'; Id='Microsoft.VisualStudioCode'},
        @{Name='Sublime Text'; Id='SublimeHQ.SublimeText.4'},
        @{Name='Docker Desktop'; Id='Docker.DockerDesktop'},
        @{Name='DBeaver Community'; Id='DBeaver.DBeaver'},
        @{Name='Discord'; Id='Discord.Discord'},
        @{Name='ScreenToGif'; Id='NickeManarin.ScreenToGif'},
        @{Name='OBS Studio'; Id='OBSProject.OBSStudio'}
    )

    if ($Apps) {
        $defaultApps = $Apps | ForEach-Object { @{Name=$_; Id=$_} }
    }

    foreach ($app in $defaultApps) {
        Install-WingetPackage -Id $app.Id -Name $app.Name
    }

    Write-Log -Message 'Final da instalação de aplicativos.' -Level Info
    Write-Host 'Instalação concluída.' -ForegroundColor Cyan
} catch {
    Write-Log -Message "Falha geral: $_" -Level Error
    Write-Error $_
    exit 1
}
