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

Write-Host "Todos os aplicativos foram instalados (se não houve erros)." -ForegroundColor Cyan
