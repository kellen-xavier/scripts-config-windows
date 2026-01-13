<#
.SYNOPSIS
Configura ambiente de desenvolvimento com Git, Node/NVM, JDKs e .NET.
.DESCRIPTION
Usa winget de forma idempotente, suporta -WhatIf/-Confirm e gera logs.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param()

Import-Module -Force "$PSScriptRoot\modules\WinSetup.psm1"

try {
    Assert-Admin
    Ensure-Winget
    Write-Log -Message 'Início da configuração de desenvolvimento.' -Level Info

    Install-WingetPackage -Id 'Git.Git' -Name 'Git'
    Install-WingetPackage -Id 'CoreyButler.NVMforWindows' -Name 'NVM for Windows'
    Install-WingetPackage -Id 'OpenJS.NodeJS.LTS' -Name 'Node.js LTS'
    Install-WingetPackage -Id 'OpenJS.NodeJS' -Name 'Node.js Current'

    Install-WingetPackage -Id 'EclipseAdoptium.Temurin.11.JDK' -Name 'JDK 11'
    Install-WingetPackage -Id 'EclipseAdoptium.Temurin.17.JDK' -Name 'JDK 17'

    Install-WingetPackage -Id 'Microsoft.DotNet.SDK.6' -Name '.NET SDK 6'
    Install-WingetPackage -Id 'Microsoft.DotNet.SDK.7' -Name '.NET SDK 7'

    Write-Log -Message 'Configuração de desenvolvimento concluída.' -Level Info
    Write-Host 'Configuração concluída.' -ForegroundColor Cyan
} catch {
    Write-Log -Message "Falha na configuração: $_" -Level Error
    Write-Error $_
    exit 1
}
