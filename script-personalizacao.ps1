# Verifica permissões de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script precisa ser executado como administrador." -ForegroundColor Red
    Start-Process powershell -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"" + $MyInvocation.MyCommand.Definition + "`"") -Verb RunAs
    exit
}

# Remover todos os atalhos da área de trabalho
Write-Host "Removendo todos os atalhos da área de trabalho..."
Remove-Item "$env:USERPROFILE\Desktop\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Atalhos removidos com sucesso!" -ForegroundColor Green

# Alterar papel de parede
Write-Host "Alterando o papel de parede..."
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
    [Wallpaper]::SystemParametersInfo(20, 0, $wallpaperPath, 0x01 -bor 0x02)
    Write-Host "Papel de parede alterado para $wallpaperPath." -ForegroundColor Green
} else {
    Write-Host "Arquivo de papel de parede não encontrado: $wallpaperPath" -ForegroundColor Red
}

# Configurar navegador padrão (Google Chrome)
Write-Host "Definindo Google Chrome como navegador padrão..."
Start-Process -FilePath "chrome.exe" -ArgumentList "--make-default-browser" -Wait
Write-Host "Google Chrome definido como navegador padrão!" -ForegroundColor Green

# Alterar tema para rosa no Windows
Write-Host "Alterando tema do Windows para rosa..."
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "AccentColor" -Value 0xFFCDAF  # Código hexadecimal para rosa
Write-Host "Tema rosa aplicado com sucesso!" -ForegroundColor Green

# Desativar aplicativos inúteis utilizando o Win11Debloat
Write-Host "Baixando e executando o Win11Debloat para desativar aplicativos inúteis..."
$debloatRepo = "https://github.com/Raphire/Win11Debloat/archive/refs/heads/main.zip"
$debloatPath = "$PSScriptRoot\Win11Debloat"
Invoke-WebRequest -Uri $debloatRepo -OutFile "$PSScriptRoot\Win11Debloat.zip"
Expand-Archive -Path "$PSScriptRoot\Win11Debloat.zip" -DestinationPath $debloatPath -Force
cd "$debloatPath\Win11Debloat-main"
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\Win11Debloat.ps1" -Verb RunAs -Wait
Write-Host "Win11Debloat executado com sucesso!" -ForegroundColor Green

Write-Host "Personalização concluída com sucesso!" -ForegroundColor Cyan
