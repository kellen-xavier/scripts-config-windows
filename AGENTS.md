# Arquivo de scirpt PowerShell para configuração Windows

Repositório de scripts voltado para Windows: instalar e personalizar via Shell Script.
Este repositório foi criado com o intuito de facilitar a instalação de Aplicativos Windows. Criar o arquivo programas-new-apps.ps1

## REGRAS: O script deve conter

- Implementar Testes com Pester
- Usar análise estática de código
- Usar winget como gerenciador principal
- Instale programas com segurança usando winget
- Verificar se o winget está instalado
- Instalar programas de forma idempotente (não reinstalar se já existir)
- Usar parâmetros silenciosos
- Gerar log de execução
- Falhar de forma segura em caso de erro
- Não baixar executáveis diretamente da internet
- Seguir boas práticas de segurança no Windows
- Download e Execução de Script Externo com validação (Win11Debloat)
- Instalar gerenciadores de versão (Instalação de Múltiplas Versões do Java/Node.js)
- Deve conter blocos de help
- script verifica conectividade antes de tentar downloads.
- Adicionar Suporte a -WhatIf e -Confirm
- Transformar scripts em módulo PowerShell com funções reutilizáveis.
- consistência nos Nomes dos Scripts
- Verificação de Código de Saída (Uso de $LASTEXITCODE para validar sucesso das operações winget.)
- Feedback Visual ao Usuário (Uso de Write-Host com cores para indicar status das operações.)
- Todos os scripts principais possuem verificação de permissões administrativas no início.

## Liste exemplos comuns de software

### Trabalho uso VPNs

- VPN: Netskope Client

### Aplicativos

Android Studio
BlueStacks 5
Bitwarden
Cursor
Docker Desktop
DBeaver Community
Discord
Flameshot
Global VPN Cliente
LibreOffice
Powershell
PowerToys Awake
Intellij IDEA Community Edition
ScreenToGif
sqldeveloper
Sublime Text Free
Teams
Insonia
Obsidian
VS Code
Visual Studio Instaler
Logitech G Hub

### Navegadores

Google Chrome
Edge
Firefox
Opera

### Linguagens Desenvolvimento

- JAVA 11, 17, 18 +
- NodeJS
- Python

## Documentação README.md

- especifica versão mínima do Windows 10 (requer 1809+ para winget)
- necessidade do App Installer atualizado
- seção de troubleshooting

### Registry com Backup

```shell
$BackupPath = "$PSScriptRoot\backup\registry-$(Get-Date -Format 'yyyyMMdd-HHmmss').reg"
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" $BackupPath
```

## PRIORIDADES DE CORREÇÃO PARA OS SCRIPTS EXISTENTES

- Prioridade 1 (Segurança)
Adicionar validação de hash para Win11Debloat
Criar backup do registro antes de alterações
Implementar Try-Catch em todos os scripts

- Prioridade 2 (Funcionalidade)
Implementar logging persistente
Adicionar verificação de pré-requisitos
Corrigir comando de navegador padrão

- Prioridade 3 (Manutenibilidade)
Adicionar parâmetros aos scripts
Implementar idempotência
Adicionar comment-based help

## Referências

- [Examples of Comment-based Help:](https://learn.microsoft.com/en-us/powershell/scripting/developer/help/examples-of-comment-based-help?view=powershell-7.5)

- [Native interoperability best practices:](https://learn.microsoft.com/en-us/dotnet/standard/native-interop/best-practices)

- [Approved Verbs for PowerShell Commands:](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands?view=powershell-7.5)

- [PSScriptAnalyzer:](https://github.com/PowerShell/PSScriptAnalyzer)

- [The test framework for Powershell:](https://pester.dev/)

- [Starting Windows PowerShell:](https://learn.microsoft.com/en-us/powershell/scripting/windows-powershell/starting-windows-powershell?view=powershell-7.4#with-administrative-privileges-run-as-administrator)
