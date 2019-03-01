function Show-Rhino {
    param ()

$Username = (([Security.Principal.WindowsIdentity]::GetCurrent()).Name).toupper()
$IPAddress = try {@(Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.DefaultIpGateway})[0].IPAddress[0]} catch {"Disconnected"}

Write-Host "                                 ,%#*                    ." -ForegroundColor Red
Write-Host "                               .,*(%%(*,.           .    //" -ForegroundColor Red
Write-Host "                          *(%%%%%%%%%%%%%%%#*.      (#   #%*" -ForegroundColor Red
Write-Host "                     ./#%%%%%%%%%%%%%%%%%%%%%%%(.  /%%/ *%%(" -ForegroundColor Red
Write-Host "                ,/#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#/%%%#" -ForegroundColor Red
Write-Host "  ,****//(##%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#. (%%%%%%%%%%(" -ForegroundColor Red
Write-Host " *%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##%%%%%%%%%%%*" -ForegroundColor Red
Write-Host ".#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/" -ForegroundColor Red
Write-Host "*%%%%%%%%%%%%%%%%%% SYNAPSYS IT %%%%%%%%%%%%%%%%%%%%%%%%%/" -ForegroundColor Red
Write-Host "/%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#." -ForegroundColor Red
Write-Host "(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%( .,*//(((/*," -ForegroundColor Red
Write-Host "(%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/" -ForegroundColor Red
Write-Host "/%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%/" -NoNewline -ForegroundColor Red ; Write-Host "`tUserName: " -ForegroundColor Red  -NoNewline
Write-Host "`t$UserName" -ForegroundColor White
Write-Host ",%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#" -NoNewline -ForegroundColor Red ; Write-Host "`t`tComputer: " -ForegroundColor Red   -NoNewline
Write-Host "`t$env:Computername" -ForegroundColor White
Write-Host ".#%%%%%%%%%(.,*(#%%%%%%%%%%%%%%%%%%%%%*" -NoNewline -ForegroundColor Red ; Write-Host "`t`tIPAddress: " -ForegroundColor Red   -NoNewline
Write-Host "`t$IPAddress" -ForegroundColor White
Write-Host " /%%%%%%%%#.                *%%%%%%%%#." -NoNewline -ForegroundColor Red ; Write-Host "`t`tPSVer.: " -ForegroundColor Red   -NoNewline
Write-Host "`t$($PSVersionTable.PSVersion.ToString())" -ForegroundColor White
Write-Host " .%%%%%%%%/                  /%%%%%%%/" -ForegroundColor Red
Write-Host "  /%%%%%%%*                  .#%%%%%%*" -ForegroundColor Red
Write-Host "  .#%%%%%%,                   (%%%%%%," -ForegroundColor Red
Write-Host "   ,%%%%%%,                   *%%%%%%." -ForegroundColor Red
Write-Host ""
Write-Host ""

}

