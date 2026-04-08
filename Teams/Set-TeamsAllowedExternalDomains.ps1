# Instalar módulo se necessário
Install-Module MicrosoftTeams -Force

# Conectar ao Teams
Connect-MicrosoftTeams

# Ler domínios do arquivo
$novosDominios = Get-Content "C:\temp\domainexternallow.txt" | Where-Object { $_.Trim() -ne "" } | ForEach-Object { $_.Trim() }

# Buscar domínios já configurados atualmente
$configAtual = Get-CsTenantFederationConfiguration
$dominiosAtuais = $configAtual.AllowedDomains.AllowedDomain | ForEach-Object { $_.Domain }

# Combinar domínios existentes + novos (sem duplicatas)
$todosDominios = ($dominiosAtuais + $novosDominios) | Sort-Object -Unique

# Montar a lista no formato correto
$listaFinal = $todosDominios | ForEach-Object { New-CsEdgeDomainPattern -Domain $_ }

# Aplicar a configuração
Set-CsTenantFederationConfiguration -AllowedDomains (New-CsEdgeAllowList -AllowedDomain $listaFinal)

Write-Host "Concluído! Total de domínios configurados: $($todosDominios.Count)"
