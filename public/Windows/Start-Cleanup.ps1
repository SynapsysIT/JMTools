Function Start-Cleanup {
<#
.CREATED BY:
    Matthew A. Kerfoot
.CREATED ON:
    10\17\2013
.Synopsis
   Aautomate cleaning up a C: drive with low disk space
.DESCRIPTION
   Cleans the C: drive's Window Temperary files, Windows SoftwareDistribution folder, `
   the local users Temperary folder, IIS logs(if applicable) and empties the recycling bin. `
   All deleted files will go into a log transcript in C:\Windows\Temp\. By default this `
   script leaves files that are newer than 7 days old however this variable can be edited.
.EXAMPLE
   PS C:\Users\mkerfoot\Desktop\Powershell> .\cleanup_log.ps1
   Save the file to your desktop with a .PS1 extention and run the file from an elavated PowerShell prompt.
.NOTES
   This script will typically clean up anywhere from 1GB up to 15GB of space from a C: drive.
.FUNCTIONALITY
   PowerShell v3
#>
function global:Write-Verbose ( [string]$Message )

# check $VerbosePreference variable, and turns -Verbose on
{ if ( $VerbosePreference -ne 'SilentlyContinue' )
{ Write-Host " $Message" -ForegroundColor 'Yellow' } }

## Begin the timer.
$Starters = (Get-Date)
$VerbosePreference = "Continue"
$DaysToDelete = 7
$LogDate = get-date -format "MM-d-yy-HH"
$ErrorActionPreference = "silentlycontinue"

## Cleans all code off of the screen.
Clear-Host
Start-Transcript -Path C:\Windows\Temp\$LogDate.log
Write-Verbose "retriving current Disk percent free for comparison once the script has completed."
$Before = Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName,
@{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } },
@{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f( $_.Size / 1gb)}},
@{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) } },
@{ Name = "PercentFree" ; Expression = {"{0:P1}" -f( $_.FreeSpace / $_.Size ) } } |
Format-Table -AutoSize | Out-String                      
                    
## Stops the windows update service. 
Get-Service -Name wuauserv | Stop-Service -Force -Verbose -ErrorAction SilentlyContinue
## Windows Update Service has been stopped successfully!

## Deletes the contents of windows software distribution.
Get-ChildItem "C:\Windows\SoftwareDistribution\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays(-$DaysToDelete)) } |
remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue
Write-Verbose "The Contents of Windows SoftwareDistribution have been removed successfully!"

## Deletes the contents of the Windows Temp folder.
Get-ChildItem "C:\Windows\Temp\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue |
Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays(-$DaysToDelete)) } |
remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue
Write-Verbose "The Contents of Windows Temp have been removed successfully!"
             
## Delets all files and folders in user's Temp folder. 
Get-ChildItem "C:\users\*\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue |
Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays(-$DaysToDelete))} |
remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue
Write-Verbose "The contents of C:\users\$env:USERNAME\AppData\Local\Temp\ have been removed successfully!"
                    
## Remove all files and folders in user's Temporary Internet Files. 
Get-ChildItem "C:\users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" `
-Recurse -Force -Verbose -ErrorAction SilentlyContinue |
Where-Object {($_.CreationTime -le $(Get-Date).AddDays(-$DaysToDelete))} |
remove-item -force -recurse -ErrorAction SilentlyContinue
Write-Verbose "All Temporary Internet Files have been removed successfully!"
                    
## Cleans IIS Logs if applicable.
Get-ChildItem "C:\inetpub\logs\LogFiles\*" -Recurse -Force -ErrorAction SilentlyContinue |
Where-Object { ($_.CreationTime -le $(Get-Date).AddDays(-60)) } |
Remove-Item -Force -Verbose -Recurse -ErrorAction SilentlyContinue
Write-Verbose "All IIS Logfiles over $DaysToDelete days old have been removed Successfully!"

$After =  Get-WmiObject Win32_LogicalDisk | Where-Object { $_.DriveType -eq "3" } | Select-Object SystemName,
@{ Name = "Drive" ; Expression = { ( $_.DeviceID ) } },
@{ Name = "Size (GB)" ; Expression = {"{0:N1}" -f( $_.Size / 1gb)}},
@{ Name = "FreeSpace (GB)" ; Expression = {"{0:N1}" -f( $_.Freespace / 1gb ) } },
@{ Name = "PercentFree" ; Expression = {"{0:P1}" -f( $_.FreeSpace / $_.Size ) } } |
Format-Table -AutoSize | Out-String

## Stop timer.
$Enders = (Get-Date)

## Calculate amount of seconds your code takes to complete.
Write-Verbose "Elapsed Time: $(($Enders - $Starters).totalseconds) seconds"

Write-Verbose "looking for any large .ISO and or .VHD\.VHDX files."

## Sends some before and after info for ticketing purposes
Hostname ; Get-Date | Select-Object DateTime
Write-Verbose "Before: $Before"
Write-Verbose "After: $After"
Write-Verbose ( Get-ChildItem -Path C:\* -Include *.iso, *.vhd, *.vhdx -Recurse -ErrorAction SilentlyContinue | 
                Sort Length -Descending | Select-Object Name, Directory,
                @{Name="Size (GB)";Expression={ "{0:N2}" -f ($_.Length / 1GB) }} | Format-Table | 
                Out-String )

## Completed Successfully!
Stop-Transcript
}