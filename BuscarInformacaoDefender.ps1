<#
.SYNOPSIS
Este script verifica o status do Windows Defender em computadores listados em "C:\temp\individual0.txt" e cria um relatório.
.DESCRIPTION
O script verifica o status do Windows Defender, incluindo a habilitação do Antivírus, Proteção em Tempo Real, Ativação do NIS, data da última atualização de assinatura e versão do produto. Ele gera um relatório em "C:\temp\individual00.txt" com essas informações.
.NOTES
Autor: Mikio Nakamaru
#>

$outputcsv = "C:\temp\individual00.txt"
$hostlist = Get-Content "C:\temp\individual0.txt"
$OutputMessage = @()
$OutputMessage | Out-File $outputcsv -Encoding utf8 -Append
$Count = 0

foreach ($comp in $hostlist) {
    "============================================================="
    $Count = $Count + 1
    "($Count) - " + "CumputerName : " + $comp
    Get-Date

    $pingtest = Test-Connection -ComputerName $comp -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($pingtest) {
        $Defender = Get-CimInstance -ClassName MSFT_MpComputerStatus -Namespace root/microsoft/windows/defender -ComputerName $comp | Select-Object -Property Antivirusenabled, AMServiceEnabled, AntispywareEnabled, BehaviorMonitorEnabled, IoavProtectionEnabled, `
            NISEnabled, OnAccessProtectionEnabled, RealTimeProtectionEnabled, AntivirusSignatureLastUpdated, AMProductVersion

        $Signature = $Defender.AntivirusSignatureLastUpdated
        $NISEnable = $Defender.NISEnabled
        $Version = $Defender.AMProductVersion
        $RealTime = $Defender.RealTimeProtectionEnabled

        If ($null -ne $NISEnable) { $NISEnable } else { $NISEnable = "NA" }

        "Status NIS                         : " + $NISEnable
        "Status Real Time Protection        : " + $RealTime
        "Status Signature                   : " + $Signature
        "Status Version                     : " + $Version

        $OutputMessage += "$comp,Online,$Sense,$NISEnable,$RealTime,$Signature,$Version"
    }
    else {
        $OutputMessage += "$comp,Offline"
    }
}

$OutputMessage | Out-File $outputcsv -Encoding utf8 -Append