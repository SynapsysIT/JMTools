###############################################################################################################
# Language     :  PowerShell 5.0
# Filename     :  Start-PortScan.ps1
# Autor        :  Julien Mazoyer
# Description  :  Start a port scan on the selected computer.
###############################################################################################################

<#
      .SYNOPSIS
      Test-Port is an advanced Powershell function. Test-OpenPort acts like a port scanner.
  
      .DESCRIPTION
      Uses Test-NetConnection. Define multiple targets and multiple ports.
  
      .EXAMPLE
      Test-Port -Target google.com -Port 80,443
#>  
function Test-Port
{
   
    [CmdletBinding()]
  
    param
    (
        [Parameter(Position = 0)]
        $Target = 'localhost', 
  
        [Parameter(Mandatory = $true, Position = 1, Helpmessage = 'Enter Port Numbers. Separate them by comma.')]
        $Port
    )
  
    $result = @()
  
    foreach ($i in $Target)
      
    {
        foreach ($p in $Port)
              
        {
          
            $a = Test-NetConnection -ComputerName $i -Port $p -WarningAction SilentlyContinue
  
                         
                              
            $result += New-Object -TypeName PSObject -Property ([ordered]@{
                    'Target'        = $a.ComputerName;
                    'RemoteAddress' = $a.RemoteAddress;
                    'Port'          = $a.RemotePort;
                    'Status'        = $a.tcpTestSucceeded
                })    
                                  
        }
        
    }
  
    Write-Output $result
}
  