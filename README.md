# Scripts para Personalização e Configuração do Windows

>Este repositório contém scripts em PowerShell para diferentes finalidades: instalação de aplicativos, configuração do ambiente de desenvolvimento e personalização do sistema Windows.

## Scripts Disponíveis

- Script de Aplicativos
- Script de Desenvolvimento (instaladores básicos para trabalhar com dev)
- Script de Personalização (trabalhar em ambiente legal também 💗)

### 1. **script-apps-e-ferramentas.ps1 e script-aplicativos.ps1**

- **Objetivo:** Instalar aplicativos comuns no Windows, como navegadores, ferramentas de gravação de tela e comunicação.
- **Aplicativos Instalados:**
  - Firefox
  - Google Chrome
  - Opera
  - Spotify
  - Discord
  - ScreenToGif
  - OBS Studio
  - VS Code
  - Sublime Text
  - Docker Desktop
  - DBeaver
  - Visual Studio Community

### 2. **script-config-desenvolvimento.ps1**

- **Objetivo:** Configurar o ambiente Windows para desenvolvimento.
- **Ferramentas Instaladas:**

  - Git
  - Node.js (versões 16, 18 e a última versão)
  - Java (versões 11, 17, 18 e a última versão)
  - Chocolatey
  - CSharp

### 3. **script-personalizacao.ps1**

- **Objetivo:** Personalizar o sistema Windows com as seguintes configurações:

  - Remover atalhos da área de trabalho.
  - Definir um papel de parede personalizado.
  - Configurar Google Chrome como navegador padrão.
  - Aplicar um tema rosa ao Windows.
  - Remover aplicativos inúteis do sistema utilizando o [Win11Debloat](https://github.com/Raphire/Win11Debloat).

## Pré-requisitos

1. **Sistema Operacional:** Windows 10 (1809+) ou Windows 11.
2. **App Installer:** Deve estar atualizado para habilitar o winget.
3. **Permissões de Administrador:**
   - Todos os scripts precisam ser executados com permissões administrativas.
4. **PowerShell:** Versão 5.1 ou superior.
5. **Configuração do Execution Policy:** Certifique-se de que o PowerShell permite a execução de scripts:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```

6. **Requisitos Específicos do Script de Personalização:**
   - Coloque o seu papel de parede na pasta `wallpaper`, localizada no mesmo diretório do script. O arquivo deve se chamar `wallpaper-cute.jpg`.

## Como Executar os Scripts

### 1. Baixar os Scripts

- Clone ou baixe este repositório:

  ```bash
  git clone https://github.com/kellen-xavier/scripts-config-windows
  ```

### 2. Executar um Script

1. Abra o **PowerShell** como administrador.
2. Navegue até o diretório onde está o script.
3. Execute o script desejado:

   ```powershell
   .\nome-do-script.ps1
   ```

### Exemplos

- Para instalar aplicativos:

  ```powershell
  .\programas-new-apps.ps1
  ```

- Para configurar o ambiente de desenvolvimento:

  ```powershell
  .\script-config-desenvolvimento.ps1
  ```

- Para personalizar o sistema:

  ```powershell
  .\script-personalizacao.ps1
  ```

---

## Observações

- Certifique-se de ter uma conexão estável com a internet para que os downloads sejam concluídos corretamente.
- O script de personalização utiliza o repositório [Win11Debloat](https://github.com/Raphire/Win11Debloat) para desativar aplicativos desnecessários. Verifique a documentação do projeto para mais detalhes.
- Após a execução dos scripts, reiniciar o sistema pode ser necessário para aplicar todas as configurações.

---

## Troubleshooting

- Erro: winget não encontrado → Atualize o App Installer pela Microsoft Store e garanta Windows 10 1809+.
- Falha de conectividade → Verifique acesso a github.com e proxies/VPN.
- Execução bloqueada → Ajuste o Execution Policy conforme seção de Pré-requisitos.

## Suporte

Caso tenha dúvidas ou problemas ao executar os scripts, entre em contato pelo [perfil do github](https://github.com/kellen-xavier)
