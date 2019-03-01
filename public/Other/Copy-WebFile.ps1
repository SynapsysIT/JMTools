Function Copy-WebFile
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.Uri]$Source,
        [Parameter()]
        [System.String]$DownloadPath=$Pwd.path

    )

    $FileName=Split-Path $Source.AbsolutePath -Leaf
    $Destination=Join-Path $DownloadPath $FileName
    $webclient = New-Object System.Net.WebClient
    $webclient.DownloadFile($Source,$Destination)

}