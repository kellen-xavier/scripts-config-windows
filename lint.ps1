param()

Write-Host 'Running ScriptAnalyzer...' -ForegroundColor Cyan
Invoke-ScriptAnalyzer -Path $PSScriptRoot -Recurse -Severity Warning
