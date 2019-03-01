<#
.SYNOPSIS
    Function de Log

.DESCRIPTION
    Function pour logger dans la console et dans un fichier

.EXAMPLE
    # D?marrer le script
    Write-Log -StartLog -LogFile $LogFile

    Write-Log -Level Error -Message "Message d'erreur" -LogFile $LogFile
    Write-Log -Level Warn -Message "Message d'avertissement" -LogFile $LogFile
    Write-Log -Level Info -Message "Message d'info" -LogFile $LogFile

    #Ecrire le r?sultat d'une ?tape 
    Write-Log -Step -Message "OK" -LogFile $LogFile

    #Finir le script
    Write-Log -Endlog -LogFile $LogFile

    #Definir le param?tre LogFile par defaut :
    
    $LogFile = 'C:\logs\mylogfile.log'
    $PSDefaultParameterValues = @{ 'Write-Log:LogFile'   = $LogFile}


.NOTES
    ##################################################################
    Author:     Julien Mazoyer
    Name:       Write-Host
    
    Date        
    10/04/2018      Creation
    ##################################################################
 #>

 function Write-Log 
 {
     [CmdletBinding()]
     Param (
         [Parameter(Mandatory = $true, ParameterSetName = "Message", ValueFromPipeline = $true)][string]$Message,
         [Parameter(Mandatory = $false, ParameterSetName = "Message")] [ValidateSet("Info", "Error", "Warn")][string]$Level = "Info",
         [Parameter(Mandatory = $false, ParameterSetName = "Message", ValueFromPipeline = $true)][switch]$Step,           
         [Parameter(Mandatory = $true, ParameterSetName = "StartLog", ValueFromPipeline = $true)][switch]$StartLog,
         [Parameter(Mandatory = $true, ParameterSetName = "EndLog", ValueFromPipeline = $true)][switch]$EndLog,
         [Parameter(Mandatory = $false)][string]$Color = "Green",      
         [Parameter(Mandatory = $true, ValueFromPipeline = $true)][string]$LogFile
     )
 
     #=============================================
     # EXECUTION
     #=============================================
 
 
     Switch ($PsCmdlet.ParameterSetName)
     {
         "StartLog" # HEADER
         {
             $CurrentScriptName = $myinvocation.ScriptName
             $script:StartDate = Get-Date
             $LogStartDate_str = Get-Date -UFormat "%d-%m-%Y %H:%M:%S"
 
             #Information Syst?me & Contexte
             $Current = [Security.Principal.WindowsIdentity]::GetCurrent()
             $CurrentUser = $Current.Name
             $CurrentComputer = $ENV:COMPUTERNAME
             #System
             if ($PSVersionTable.PSVersion -gt "4.0"){
                 $CIM = Get-CimInstance win32_operatingsystem -Property Caption, Version, OSArchitecture
             }
             else 
             {
                 $CIM = Get-WmiObject win32_operatingsystem -Property Caption, Version, OSArchitecture
             }
             $OS = "$($CIM.Caption) [$($CIM.OSArchitecture)]"
             $OSVersion = $CIM.Version
             $PSVersion = ($PSVersionTable.PSVersion)
             #UAC
             #determine the current user so we can test if the user is running in an elevated session
             $Principal = [Security.Principal.WindowsPrincipal]$Current
             $Elevated = $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
 
             $Header = "+========================================================================================+`r`n"
             $Header += "Script Name                     : $CurrentScriptName`r`n"
             $Header += "When generated                  : $LogStartDate_str`r`n"
             $Header += "User                            : $CurrentUser`r`n"
             $Header += "Elevated                        : $Elevated`r`n"
             $Header += "Computer                        : $CurrentComputer`r`n"
             $Header += "OS                              : $OS`r`n"
             $Header += "OS Version                      : $OSVersion`r`n"
             $Header += "PS Version                      : $PSVersion`r`n"
             $Header += "+========================================================================================+`n"
 
 
             # Log file creation
             [VOID] (New-Item -ItemType File -Path $LogFile -Force)
             $Header | Out-File -FilePath $LogFile -Append -Encoding UTF8
             Write-Host $Header -ForegroundColor Cyan
             break
         }
 
         "Message" #LOG
         {
            if ($Step.IsPresent)
            {
                switch ($Level)
                {
                    Info    { $Icon  = "`t[+]"  ;break}
                    Error   { $Icon  = "`t[x]"  ; break}
                    Warn    { $Icon  = "`t[!]"  ;break}
                }
            }
            else
            {
                $Icon = ""
            }

             $TimeStamp = Get-Date -UFormat "%H:%M:%S"
             switch ($Level)
             {
                 Info { $Line  = ("[{0}][INFO   ] {1} {2}" -f $TimeStamp,$Icon, $Message); $Color = 'Cyan'; break }
                 Error { $Line = ("[{0}][ERROR  ] {1} {2}" -f $TimeStamp,$Icon, $Message); $Color = 'Red'; break }
                 Warn { $Line  = ("[{0}][WARNING] {1} {2}" -f $TimeStamp,$Icon, $Message); $Color = 'Yellow'; break }
             }

             Write-Host $Line -ForegroundColor $Color
             "$Line" | Out-File -FilePath $LogFile -Append -Encoding UTF8
 
             break
         }
 
         "Step" #Status d'un ?tape sur la meme ligne
         {
            switch ($Level)
            {
                Info    { $Icon  = "`t[+]"  ;break}
                Error   { $Icon  = "`t[x]"  ; break}
                Warn    { $Icon  = "`t[!]"  ;break}
            }
             $Message = "$($Icon) $Message"
             
 
             #Déplacement Cursor
              $ConsoleY = ([System.Console]::CursorTop) - 1
              [System.Console]::SetCursorPosition(0,$ConsoleY)
 
             Write-Host $PreviousLine -ForegroundColor Cyan  -NoNewline
             Write-Host $Message -ForegroundColor $Color

             $TempContent = Get-Content $LogFile 
             $TempContent = $TempContent | Select-Object -First (($TempContent.count)-1)
             Set-Content -Path $LogFile -Value $TempContent -Encoding UTF8
            
             $Line = "$PreviousLine"+"  $Message"
             Add-Content -Path $LogFile -Value $Line -Encoding UTF8

             break
         }
 
         "EndLog" #Status d'un ?tape sur la meme ligne
         {
             $EndDate  = Get-Date
             $TimeSpan = New-TimeSpan -Start $StartDate -End $EndDate
             $Duration_Str = "{0} hours {1} min. {2} sec" -f $TimeSpan.Hours,$TimeSpan.Minutes,$TimeSpan.Seconds
             
             $Footer += "`r`n"
             $Footer += "+========================================================================================+`r`n"
             $Footer += "End Time                 : $EndDate`r`n"
             $Footer += "Total Duration           : $Duration_Str`r`n"
             $Footer += "+========================================================================================+"
 
             $Footer| Out-File -FilePath $LogFile -Append -Encoding UTF8
             Write-Host $Footer -ForegroundColor Cyan
         }
 
     }
 }

<#
Write-Log -StartLog -LogFile $LogFile

for ($i = 0; $i -lt 100; $i++) 
{
    $Level = Get-Random -InputObject @("Info","Warn","Error")
    Write-Log -Level $Level -Message "TEST DE MESSAGE $($LEVEL.toupper())" -LogFile $LogFile
    Write-Log -Step -Message "Step" -LogFile $LogFile -level $level


}

Write-Log -EndLog -LogFile $LogFile
#>