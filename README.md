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
