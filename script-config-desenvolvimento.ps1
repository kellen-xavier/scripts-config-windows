# Verifica permissões de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script precisa ser executado como administrador." -ForegroundColor Red
    Start-Process powershell -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"" + $MyInvocation.MyCommand.Definition + "`"") -Verb RunAs
    exit
}

# Atualiza o cache do Winget
Write-Host "Atualizando o cache do Winget..."
winget source update

# Lista de ferramentas para instalação
$devTools = @(
    @{Name = "Git"; PackageId = "Git.Git"}
)

# Instalação das ferramentas principais
foreach ($tool in $devTools) {
    Write-Host "Instalando $($tool.Name)..."
    winget install --id $($tool.PackageId) --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Host "$($tool.Name) instalado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "Erro ao instalar $($tool.Name)." -ForegroundColor Red
    }
}

# Instalação de versões do Node.js
Write-Host "Instalando Node.js (versões específicas)..."
winget install OpenJS.NodeJS.LTS --silent --accept-package-agreements --accept-source-agreements
winget install OpenJS.NodeJS --silent --accept-package-agreements --accept-source-agreements

# Instalação de versões do Java
Write-Host "Instalando Java (versões específicas)..."
$javaVersions = @("11", "17", "18")
foreach ($version in $javaVersions) {
    Write-Host "Instalando Java $version..."
    winget install --id "Oracle.JavaRuntimeEnvironment.$version" --silent --accept-package-agreements --accept-source-agreements
}
winget install --id "Oracle.JavaRuntimeEnvironment" --silent --accept-package-agreements --accept-source-agreements

# Instalação de CSharp (via dotnet)
Write-Host "Instalando .NET SDK para CSharp..."
winget install Microsoft.DotNet.SDK.6 --silent --accept-package-agreements --accept-source-agreements
winget install Microsoft.DotNet.SDK.7 --silent --accept-package-agreements --accept-source-agreements

Write-Host "Configuração de ambiente de desenvolvimento concluída." -ForegroundColor Cyan
