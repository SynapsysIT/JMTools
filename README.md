## Présentation

Ma boite à outils Powershell, l'ensemble des functions que j'utilise quotidiennement.

## Installation

```powershell
cd ($env:PSModulePath -split ";")[0]
git clone https://git.reyozam.xyz/Xeph/JMTools.git
```
## Les Principales functions

 **Write-LineProgress:**
Permet d'afficher une barre dans la console

 ````powershell
for ($i = 0; $i -le 100; $i++) 
{
    Write-LineProgress -Activity "Demo" -Progress $i    
}
 ```
 
![Write-Log](images/lineprogress.gif)


 **Write-Log:**
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


## Functions

```powershell
Get-Command -Module JMTools

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        ConvertFrom-Base64                                 1.0.0      JMTools
Function        ConvertFrom-CredentialFileToCredential             1.0.0      JMTools
Function        ConvertFrom-ErrorRecord                            1.0.0      JMTools
Function        Convert-IPv4Address                                1.0.0      JMTools
Function        Convert-Subnetmask                                 1.0.0      JMTools
Function        ConvertTo-Base64                                   1.0.0      JMTools
Function        Copy-WebFile                                       1.0.0      JMTools
Function        Export-DomainGPOs                                  1.0.0      JMTools
Function        Find-StringInFile                                  1.0.0      JMTools
Function        Get-ARPCache                                       1.0.0      JMTools
Function        Get-Busy                                           1.0.0      JMTools
Function        Get-CredentialVault                                1.0.0      JMTools
Function        Get-GPODisabled                                    1.0.0      JMTools
Function        Get-GPOEmpty                                       1.0.0      JMTools
Function        Get-GPOMissingPermissions                          1.0.0      JMTools
Function        Get-GPOUnlinked                                    1.0.0      JMTools
Function        Get-GpResult                                       1.0.0      JMTools
Function        Get-InstalledSoftware                              1.0.0      JMTools
Function        Get-IPv4Subnet                                     1.0.0      JMTools
Function        Get-LastBootTime                                   1.0.0      JMTools
Function        Get-RegistryKeyEntries                             1.0.0      JMTools
Function        Get-UserGroupMembership                            1.0.0      JMTools
Function        Get-Who                                            1.0.0      JMTools
Function        Get-WindowsProductKey                              1.0.0      JMTools
Function        Get-WUFileByID                                     1.0.0      JMTools
Function        Install-Rsat                                       1.0.0      JMTools
Function        Invoke-Sudo                                        1.0.0      JMTools
Function        Invoke-Supervision                                 1.0.0      JMTools
Function        New-Password                                       1.0.0      JMTools
Function        Out-HTML                                           1.0.0      JMTools
Function        Save-CredentialVault                               1.0.0      JMTools
Function        Set-EnvironmentVariable                            1.0.0      JMTools
Function        Set-TaskbarNotification                            1.0.0      JMTools
Function        Show-Rhino                                         1.0.0      JMTools
Function        Start-AllDCReplication                             1.0.0      JMTools
Function        Start-Cleanup                                      1.0.0      JMTools
Function        Start-KeyLogger                                    1.0.0      JMTools
Function        Start-PortScan                                     1.0.0      JMTools
Function        Start-ProcessWithCapture                           1.0.0      JMTools
Function        Test-ADUserExists                                  1.0.0      JMTools
Function        Test-Credential                                    1.0.0      JMTools
Function        Update-ACL                                         1.0.0      JMTools
Function        Update-StringInFile                                1.0.0      JMTools
Function        Write-Color                                        1.0.0      JMTools
Function        Write-Log                                          1.0.0      JMTools
```