# Présentation

Ma boite à outils Powershell, l'ensemble des functions que j'utilise quotidiennement.

# Installation

```powershell
cd ($env:PSModulePath -split ";")[0]
git clone https://git.reyozam.xyz/Xeph/JMTools.git
```
ou 
Télécharger : https://github.com/SynapsysIT/JMTools/archive/master.zip
Dézipper le contenu dans C:\%username%\Documents\WindowsPowershell\Modules\JMTools

# Quelques Demos...

## Out-HTML

Permet de créér un rapport HTML personnalisé avec son code CSS
et de colorer les lignes en fonction de leurs contenus.

 ```powershell
Get-Service | Select-Object Name,Status | Out-HTML -Path .\ServiceReport.html -Title "Services" -SuccessMatch "Running" -ErrorMatch "Stopped"
 ```
 ![Out-HTML](images/outhtml.gif)


## Write-Log
 
 Functions permettant le log visuel dans la console et le log dans un fichier simultanément

 ```powershell
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

 ```powershell
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

Name                      | Description                                           | Link                                                
------------------------- | ----------------------------------------------------- | -----------------------------------------------------
ConvertFrom-Base64        | Convert a Base64 encoded string to a plain text st... | [LINK](public/Security/ConvertFrom-Base64.ps1)       
ConvertFrom-ErrorRecord   | Convert Powershell Error in Object to simplify exp... | [LINK](public/Other/Convertfrom-ErrorRecord.ps1)     
Convert-Subnetmask        | Convert a subnetmask like 255.255.255 to CIDR (/24... | [LINK](public/Network/Convert-Subnetmask.ps1)        
ConvertTo-Base64          | Convert a text (command) to an Base64 encoded stri... | [LINK](public/Security/ConvertTo-Base64.ps1)         
Copy-WebFile              | Download locally file from web url                    | [LINK](public/Other/Copy-WebFile.ps1)                
Export-DomainGPOs         | Export HTML Report of all GPO in a domain             | [LINK](public/AD/Export-DomainGPOs.ps1)              
Find-StringInFile         | Find String in one or more files                      | [LINK](public/File/Find-StringInFile.ps1)            
Get-ARPCache              | Get the Address Resolution Protocol (ARP) cache       | [LINK](public/Network/Get-ARPCache.ps1)              
Get-CredentialVault       | Retrieve credential from Windows Vault                | [LINK](public/Security/Get-CredentialVault.ps1)      
Get-GPODisabled           | Get GPO Settings status Enabled/Disabled              | [LINK](public/AD/Get-GPODisabled.ps1)                
Get-GPOEmpty              | Get Empty GPO Settings                                | [LINK](public/AD/Get-GPOEmpty.ps1)                   
Get-GPOMissingPermissions | Get GPO where "Authentificated Users" & "Domain Co... | [LINK](public/AD/Get-GPOMissingPermissions.ps1)      
Get-GPOUnlinked           | Get GPO with no OU Link.                              | [LINK](public/AD/Get-GPOUnlinked.ps1)                
Get-GpResult              | Custom Powershell Gpresult                            | [LINK](public/AD/Get-GPResult.ps1)                   
Get-InstalledSoftware     | Get all installed software with DisplayName, Publi... | [LINK](public/Softwares/Get-InstalledSoftware.ps1)   
Get-IPv4Subnet            |                                                       | [LINK](public/Network/Get-IPv4Subnet.ps1)            
Get-LastBootTime          | Get the time when a computer is booted.               | [LINK](public/Windows/Get-LastBootTime.ps1)          
Get-RegistryKeyEntries    | Gets all of the properties and their values in a r... | [LINK](public/Windows/Get-RegistryKeyEntries.ps1)    
Get-UserGroupMembership   | Get AD User Group Membership                          | [LINK](public/AD/Get-UserGroupMembership.ps1)        
Get-Who                   |                                                       | [LINK](public/Other/Get-Who.ps1)                     
Get-WindowsProductKey     | Get the Windows product key from a local or remote... | [LINK](public/Windows/Get-WindowsProductKey.ps1)     
Get-WUFileByID            |                                                       | [LINK](public/Windows/Get-WUFileByID.ps1)            
Install-Rsat              | Downloads and installs RSAT (Windows Remote Server... | [LINK](public/Windows/Install-Rsat.ps1)              
Invoke-Sudo               |                                                       | [LINK](public/Other/Invoke-Sudo.ps1)                 
Invoke-Supervision        | Show a graphical table with ping status of multipl... | [LINK](public/Network/Invoke-Supervision.ps1)        
New-Password              | Function to generate random password                  | [LINK](public/Security/New-Password.ps1)             
Out-HTML                  | Create a HTML Table with object send by the pipeli... | [LINK](public/Other/Out-HTML.ps1)                    
Save-CredentialVault      | Retrieve credential to Windows Vault                  | [LINK](public/Security/Save-CredentialVault.ps1)     
Set-EnvironmentVariable   | Set Environment Variable                              | [LINK](public/Windows/Set-EnvironmentVariable.ps1)   
Set-TaskbarNotification   | Create Notifications for scripts in the taskbar       | [LINK](public/Other/Set-TaskbarNotification.ps1)     
Show-Rhino                |                                                       | [LINK](public/Fun/Show-Rhino.ps1)                    
Start-AllDCReplication    | Launch All Controllers Replication                    | [LINK](public/AD/Start-AllDCReplication.ps1)         
Start-KeyLogger           |                                                       | [LINK](public/Security/Start-Keylogger.ps1)          
Start-PortScan            | Start a port scan on the selected computer on comm... | [LINK](public/Network/Start-PortScan.ps1)            
Start-ProcessWithCapture  | Start processes and capturing output.                 | [LINK](public/Softwares/Start-ProcessWithCapture.ps1)
Test-Credential           | Test an authentification in AD or local context       | [LINK](public/AD/Test-Credential.ps1)                
Test-Port                 | Uses Test-NetConnection. Define multiple targets a... | [LINK](public/Network/Test-Port.ps1)                 
Update-StringInFile       | Replace a string in one or multiple files.            | [LINK](public/File/Update-StringInFile.ps1)          
Write-Color               |                                                       | [LINK](public/Other/Write-Color.ps1)                 
Write-LineProgress        | Write Progress Bar in console                         | [LINK](public/Other/Write-LineProgress.ps1)          
Write-Log                 | Function pour logger dans la console et dans un fi... | [LINK](public/Other/Write-Log.ps1)                   
Write-Menu                |                                                       | [LINK](public/Other/Write-Menu.ps1)                  
Write-Title               | Show a Title bar in Console                           | [LINK](public/Other/Write-Title.ps1)                                                   
