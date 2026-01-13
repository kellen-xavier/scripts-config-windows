<#
.SYNOPSIS
Instala aplicativos e ferramentas comuns via winget com segurança.
.DESCRIPTION
Suporta -WhatIf/-Confirm, idempotência, logging e validação de pré-requisitos.
#>

[CmdletBinding(SupportsShouldProcess=$true)]
param()

Import-Module -Force "$PSScriptRoot\modules\WinSetup.psm1"

try {
    Assert-Admin
    Ensure-Winget
    Write-Log -Message 'Início da instalação de apps e ferramentas.' -Level Info

    $apps = @(
        @{Name = 'Google Chrome'; Id = 'Google.Chrome'},
        @{Name = 'VS Code'; Id = 'Microsoft.VisualStudioCode'},
        @{Name = 'Sublime Text'; Id = 'SublimeHQ.SublimeText.4'},
        @{Name = 'Docker Desktop'; Id = 'Docker.DockerDesktop'},
        @{Name = 'DBeaver Community'; Id = 'DBeaver.DBeaver'},
        @{Name = 'Visual Studio Community'; Id = 'Microsoft.VisualStudio.2022.Community'},
        @{Name = 'Firefox'; Id = 'Mozilla.Firefox'},
        @{Name = 'Opera Browser'; Id = 'Opera.Opera'},
        @{Name = 'Spotify'; Id = 'Spotify.Spotify'},
        @{Name = 'Discord'; Id = 'Discord.Discord'},
        @{Name = 'ScreenToGif'; Id = 'NickeManarin.ScreenToGif'},
        @{Name = 'OBS Studio'; Id = 'OBSProject.OBSStudio'}
    )

    foreach ($a in $apps) {
        Install-WingetPackage -Id $a.Id -Name $a.Name -WhatIf:$WhatIfPreference -Confirm:$ConfirmPreference
    }

    Write-Log -Message 'Instalação concluída.' -Level Info
    Write-Host 'Instalação concluída.' -ForegroundColor Cyan
} catch {
    Write-Log -Message "Falha geral: $_" -Level Error
    Write-Error $_
    exit 1
}
