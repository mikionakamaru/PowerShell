# Kill MSTeams Process
# Define uma lista com possíveis nomes do processo do Microsoft Teams
$procNames = @('ms-teams','ms-teams.exe')

# Para cada nome de processo listado
foreach ($n in $procNames) {
    # Tenta obter o processo pelo nome (sem mostrar erro caso não exista)
    Get-Process -Name $n -ErrorAction SilentlyContinue | ForEach-Object {
        # Força a finalização do processo encontrado
        Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue
    }
}

# Aguarda 3 segundos para garantir que os processos foram encerrados
Start-Sleep -Seconds 3

# Clean Cache
# Define o caminho da pasta de cache do Microsoft Teams
$Cache = Join-Path $env:LOCALAPPDATA 'Packages\MSTeams_8wekyb3d8bbwe\LocalCache\Microsoft\MSTeams'

# Verifica se a pasta de cache existe
if (-not (Test-Path $Cache)) {
    # Se não existir, encerra o script
    return
}else{
    # Remove todos os arquivos dentro da pasta de cache,
    # exceto os que estão na subpasta "Backgrounds"
    Get-ChildItem -Path $Cache -Recurse -Force |
        Where-Object { -not $_.FullName -notlike '*\Backgrounds*' } |
        Remove-Item -Force -ErrorAction SilentlyContinue

    # Remove todas as subpastas dentro do cache,
    # também ignorando a pasta "Backgrounds"
    Get-ChildItem -Path $Cache -Recurse -Force -Directory |
        Where-Object { $_.FullName -notlike '*\Backgrounds*' } |
        Sort-Object FullName -Descending |
        ForEach-Object {
            Remove-Item -LiteralPath $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
        }
}
