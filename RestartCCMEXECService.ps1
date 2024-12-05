# Define o nome do serviço que será manipulado
$ServiceName = 'CCMEXEC'

# Obtém o serviço com o nome especificado e armazena na variável $arrService
$arrService = Get-Service -Name $ServiceName

# Para o serviço especificado
Stop-Service $ServiceName;

# Aguarda 5 segundos para garantir que o serviço tenha tempo para parar
Start-Sleep -seconds 5;

# Loop para verificar se o serviço está realmente parado
while ($arrService.Status -ne 'Stopped')
{
    # Tenta parar o serviço novamente
    Stop-Service $ServiceName
    
    # Exibe o status atual do serviço
    write-host $arrService.status
    
    # Exibe uma mensagem indicando que o serviço está parando
    write-host 'Service Stopping'
    
    # Aguarda 5 segundos antes de verificar novamente
    Start-Sleep -seconds 5
    
    # Atualiza o status do serviço
    $arrService.Refresh()
}

# Verifica se o serviço está parado
if ($arrService.Status -eq 'Stopped')
{
    # Exibe uma mensagem indicando que o serviço está parado
    Write-Host 'Service is now Stopped'
    
    # Remove o arquivo de configuração específico
    remove-item C:\Windows\SMSCFG.ini;
    
    # Remove todas as entradas de certificados SMS no registro
    Remove-Item -Path HKLM:\Software\Microsoft\SystemCertificates\SMS\Certificates\* -Force;
    
    # Reinicia o serviço
    Start-Service $ServiceName
}
