$OutputMessage = @()

$Antivirus = Get-CimInstance -Namespace root/SecurityCenter2 -ClassName AntivirusProduct

foreach ($item in $Antivirus) {
    $ComputerName = $env:COMPUTERNAME
    $ProductName = $item.displayName

    $Message = "ComputerName=$ComputerName;Antivirus=$ProductName"
    $OutputMessage += $Message
}

$OutputMessage