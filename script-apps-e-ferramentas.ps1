# Script para Instalar Aplicativos e Ferramentas de Desenvolvimento

```powershell
# Verifica se o winget está instalado
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget não está instalado. Por favor, atualize o Windows para usar este script." -ForegroundColor Red
    exit
}

# Atualiza o cache do Winget
Write-Host "Atualizando o cache do Winget..."
winget source update

# Lista de aplicativos para instalar
$apps = @(
    # Aplicativos de uso geral
    @{Name = "Google Chrome"; PackageId = "Google.Chrome"},
    @{Name = "VS Code"; PackageId = "Microsoft.VisualStudioCode"},
    @{Name = "Sublime Text"; PackageId = "SublimeHQ.SublimeText.4"},
    @{Name = "Docker Desktop"; PackageId = "Docker.DockerDesktop"},
    @{Name = "DBeaver"; PackageId = "DBeaver.DBeaver"},
    @{Name = "Visual Studio Community"; PackageId = "Microsoft.VisualStudio.2022.Community"},
    @{Name = "Firefox"; PackageId = "Mozilla.Firefox"},
    @{Name = "Opera Browser"; PackageId = "Opera.Opera"},
    @{Name = "Spotify"; PackageId = "Spotify.Spotify"},
    @{Name = "Discord"; PackageId = "Discord.Discord"},
    @{Name = "ScreenToGif"; PackageId = "NickeManarin.ScreenToGif"},
    @{Name = "OBS Studio"; PackageId = "OBSProject.OBSStudio"}
)

# Instalação dos aplicativos
foreach ($app in $apps) {
    Write-Host "Instalando $($app.Name)..."
    winget install --id $($app.PackageId) --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$($app.Name) instalado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "Erro ao instalar $($app.Name)." -ForegroundColor Red
    }
}

Write-Host "Todos os aplicativos foram instalados (se não houveram erros)." -ForegroundColor Cyan
```
