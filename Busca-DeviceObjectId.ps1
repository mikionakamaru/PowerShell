<#
    Script: Consulta-ObjectIdDispositivo.ps1
    Autor: Felipe (adaptado)
    Descrição:
        Este script realiza a consulta de dispositivos registrados no Microsoft Entra ID (Azure AD),
        com base em uma lista de nomes armazenada em um arquivo de texto.

        Para cada nome de dispositivo listado em C:\Temp\devicename.txt, o script busca o objeto correspondente
        no Entra ID e extrai seu ObjectId. Os resultados são gravados em C:\Temp\objectid.txt no formato:
        NomeDoDispositivo ; ObjectId

    Requisitos:
        - Módulo AzureAD instalado (Install-Module AzureAD -Scope CurrentUser)
        - Autenticação via Connect-AzureAD
        - Permissões para consultar dispositivos no Azure AD

    Saída:
        - Arquivo de texto com os resultados da consulta, incluindo os dispositivos não encontrados.

    Observação:
        - Caso um dispositivo não seja localizado, será registrado como "NÃO LOCALIZADO".
#>

# Caminhos dos arquivos
$arquivoEntrada = "C:\Temp\devicename.txt"
$arquivoSaida   = "C:\Temp\objectid.txt"

# Conexão com Azure AD
Connect-AzureAD

# Inicializa o arquivo de saída
Set-Content -Path $arquivoSaida -Value "" -Encoding UTF8

# Carrega os nomes dos dispositivos
$listaDispositivos = Get-Content -Path $arquivoEntrada

foreach ($nomeDispositivo in $listaDispositivos) {
    Write-Host "🔍 Verificando: $nomeDispositivo"

    # Consulta no Azure AD
    $resultado = Get-AzureADDevice -Filter "displayName eq '$nomeDispositivo'" -ErrorAction SilentlyContinue

    if ($resultado) {
        foreach ($item in $resultado) {
            $linha = "$($item.DisplayName) ; $($item.ObjectId)"
            Add-Content -Path $arquivoSaida -Value $linha -Encoding UTF8
        }
    } else {
        $linha = "$nomeDispositivo ; NÃO LOCALIZADO"
        Add-Content -Path $arquivoSaida -Value $linha -Encoding UTF8
    }
}

Write-Host "✅ Finalizado! Veja os resultados em: $arquivoSaida"
