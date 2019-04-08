# Présentation

Ma boite à outils Powershell, l'ensemble des functions que j'utilise quotidiennement.

# Installation

```powershell
cd ($env:PSModulePath -split ";")[0]
git clone https://git.reyozam.xyz/Xeph/JMTools.git
```
# Quelques Demos (tape à l'oeil ;) ...

## Out-HTML

Permet de créér un rapport HTML personnalisé avec son code CSS
et de colorer les lignes en fonction de leurs contenus.

 ````powershell
Get-Service | Select-Object Name,Status | Out-HTML -Path .\ServiceReport.html -Title "Services" -SuccessMatch "Running" -ErrorMatch "Stopped"
 ```
 ![Out-HTML](images/outhtml.gif)


## Write-Log
 
 Functions permettant le log visuel dans la console et le log dans un fichier simultanément

 ````powershell
$LogFile = "C:\temp\LogFile.log"

Write-Log -StartLog -LogFile $LogFile
Write-Log -Level Info -Message "Action en cours" -LogFile $LogFile
Write-Log -Level Info -Message "Sous action ..." -Step -LogFile $LogFile
Write-Log -Level Warn -Message "Avertissement !" -LogFile $LogFile
Write-Log -Level Error -Message "Error !" -LogFile $LogFile
Write-Log -Level Success -Message "Script OK !" -LogFile $LogFile
Write-Log -EndLog -LogFile $LogFile
 ```
 
![Write-Log](images/WriteLog.png)

## Write-LineProgress
Permet d'afficher une barre dans la console

 ````powershell
for ($i = 0; $i -le 100; $i++) 
{
    Write-LineProgress -Activity "Demo" -Progress $i    
}
 ```
 
![Write-LineProgress](images/lineprogress.gif)

# Toutes les functions

```powershell
Get-Command -Module JMTools
```

 Name                     | Description                                           | LINK                                       
------------------------- | ----------------------------------------------------- | --------------------------------------------
ConvertFrom-Base64        | Convert a Base64 encoded string to a plain text st... | [LINK](public/ConvertFrom-Base64.ps1)       
ConvertFrom-ErrorRecord   | Convert Powershell Error in Object to simplify exp... | [LINK](public/ConvertFrom-ErrorRecord.ps1)  
Convert-Subnetmask        | Convert a subnetmask like 255.255.255 to CIDR (/24... | [LINK](public/Convert-Subnetmask.ps1)       
ConvertTo-Base64          | Convert a text (command) to an Base64 encoded stri... | [LINK](public/ConvertTo-Base64.ps1)         
Copy-WebFile              | Download locally file from web url                    | [LINK](public/Copy-WebFile.ps1)             
Export-DomainGPOs         | Export HTML Report of all GPO in a domain             | [LINK](public/Export-DomainGPOs.ps1)        
Find-StringInFile         | Find String in one or more files                      | [LINK](public/Find-StringInFile.ps1)        
Get-ARPCache              | Get the Address Resolution Protocol (ARP) cache       | [LINK](public/Get-ARPCache.ps1)             
Get-CredentialVault       |                                                       | [LINK](public/Get-CredentialVault.ps1)      
Get-GPODisabled           | Get GPO Settings status Enabled/Disabled              | [LINK](public/Get-GPODisabled.ps1)          
Get-GPOEmpty              | Get Empty GPO Settings                                | [LINK](public/Get-GPOEmpty.ps1)             
Get-GPOMissingPermissions | Get GPO where "Authentificated Users" & "Domain Co... | [LINK](public/Get-GPOMissingPermissions.ps1)
Get-GPOUnLINKed           | Get GPO with no OU LINK.                              | [LINK](public/Get-GPOUnLINKed.ps1)          
Get-GpResult              | Custom Powershell Gpresult                            | [LINK](public/Get-GpResult.ps1)             
Get-InstalledSoftware     | Get all installed software with DisplayName, Publi... | [LINK](public/Get-InstalledSoftware.ps1)    
Get-IPv4Subnet            |                                                       | [LINK](public/Get-IPv4Subnet.ps1)           
Get-LastBootTime          | Get the time when a computer is booted.               | [LINK](public/Get-LastBootTime.ps1)         
Get-RegistryKeyEntries    | The Get-RegistryKeyEntries cmdlet gets each entry ... | [LINK](public/Get-RegistryKeyEntries.ps1)   
Get-UserGroupMembership   | Get AD User Group Membership                          | [LINK](public/Get-UserGroupMembership.ps1)  
Get-Who                   |                                                       | [LINK](public/Get-Who.ps1)                  
Get-WindowsProductKey     | Get the Windows product key from a local or remote... | [LINK](public/Get-WindowsProductKey.ps1)    
Get-WUFileByID            |                                                       | [LINK](public/Get-WUFileByID.ps1)           
Install-Rsat              | Downloads and installs RSAT (Windows Remote Server... | [LINK](public/Install-Rsat.ps1)             
Invoke-Sudo               |                                                       | [LINK](public/Invoke-Sudo.ps1)              
Invoke-Supervision        | Show a graphical table with ping status of multipl... | [LINK](public/Invoke-Supervision.ps1)       
New-Password              | Function to generate random password                  | [LINK](public/New-Password.ps1)             
Out-HTML                  | Create a HTML Table with object send by the pipeli... | [LINK](public/Out-HTML.ps1)                 
Save-CredentialVault      |                                                       | [LINK](public/Save-CredentialVault.ps1)     
Set-EnvironmentVariable   |                                                       | [LINK](public/Set-EnvironmentVariable.ps1)  
Set-TaskbarNotification   | Create Notifications for scripts in the taskbar       | [LINK](public/Set-TaskbarNotification.ps1)  
Show-Rhino                |                                                       | [LINK](public/Show-Rhino.ps1)               
Start-AllDCReplication    | Launch All Controllers Replication                    | [LINK](public/Start-AllDCReplication.ps1)   
Start-Cleanup             |                                                       | [LINK](public/Start-Cleanup.ps1)            
Start-KeyLogger           |                                                       | [LINK](public/Start-KeyLogger.ps1)          
Start-PortScan            | Start a port scan on the selected computer on comm... | [LINK](public/Start-PortScan.ps1)           
Test-Credential           | Test an authentification in AD or local context       | [LINK](public/Test-Credential.ps1)          
Test-Port                 | Uses Test-NetConnection. Define multiple targets a... | [LINK](public/Test-Port.ps1)                
Update-ACL                | Update-ACL leverages the System.Security.AccessCon... | [LINK](public/Update-ACL.ps1)               
Update-StringInFile       | Replace a string in one or multiple files.            | [LINK](public/Update-StringInFile.ps1)      
Write-Color               |                                                       | [LINK](public/Write-Color.ps1)              
Write-LineProgress        | Write Progress Bar in console                         | [LINK](public/Write-LineProgress.ps1)       
Write-Log                 | Function pour logger dans la console et dans un fi... | [LINK](public/Write-Log.ps1)                
Write-Menu                |                                                       | [LINK](public/Write-Menu.ps1)               
Write-Title               | Show a Title bar in Console                           | [LINK](public/Write-Title.ps1)                                      
