# Include functions which are outsourced in .ps1-files
Get-ChildItem -Path "$PSScriptRoot\public" -Recurse | Where-Object {$_.Name.EndsWith(".ps1")} | ForEach-Object {. $_.FullName}