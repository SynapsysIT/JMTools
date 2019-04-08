###############################################################################################################
# Language     :  PowerShell 5.0
# Filename     :  Copy-WebFile.ps1
# Autor        :  Julien Mazoyer
# Description  :  Download locally file from web url
###############################################################################################################

<#
      .SYNOPSIS
      Download locally file from web url
  
      .DESCRIPTION
      Download locally file from web url
  
      .EXAMPLE
      PS>C:\ Copy-WebFile -Source https:\\someurl.com\file.exe -Destination $Home\Download
#> 
Function Copy-WebFile
{
 
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Uri]$Source,
        [Parameter()]
        [System.String]$DownloadPath = $Pwd.path

    )

    $FileName = Split-Path $Source.AbsolutePath -Leaf
    $Destination = Join-Path $DownloadPath $FileName
    $webclient = New-Object System.Net.WebClient
    $webclient.DownloadFile($Source, $Destination)

}