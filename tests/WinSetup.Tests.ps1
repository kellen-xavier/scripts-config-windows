$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = (Resolve-Path (Join-Path $here '..')).Path
$modulePath = Join-Path $root 'modules\WinSetup.psm1'
Import-Module $modulePath -Force

Describe "WinSetup module" {
    It "creates logs and backup directories on import" {
        Test-Path (Join-Path $root 'logs') | Should Be $true
        Test-Path (Join-Path $root 'backup') | Should Be $true
    }
    It "supports WhatIf for installation" {
        { Install-WingetPackage -Id 'Microsoft.VisualStudioCode' -Name 'VS Code' -WhatIf } | Should Not Throw
    }
    It "backup registry creates a .reg file" {
        $path = Backup-RegistryPersonalize
        Test-Path $path | Should Be $true
        Remove-Item $path -Force
    }
    It "Get-WingetPackageInstalled returns boolean" {
        $res = Get-WingetPackageInstalled -Id 'Microsoft.VisualStudioCode'
        ($res -is [bool]) | Should Be $true
    }
}
