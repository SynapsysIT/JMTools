###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Find-StringInFile.ps1
# Autor        :  Julien Mazoyer Fork from BornToBeRoot (https://github.com/BornToBeRoot)
# Description  :  Test an authentification in AD or local context
###############################################################################################################

<#
    .SYNOPSIS
    Find String in one or more files

    .DESCRIPTION
     Find String in one or more files

    .EXAMPLE

    Find-StringInFile -Path "C:\Scripts\FolderWithFiles" -Search "Test01"

	Filename    Path                      LineNumber Matches
	--------    ----                      ---------- -------
	File_01.txt E:\Temp\Files\File_01.txt          1 {Test01}
	File_02.txt E:\Temp\Files\File_02.txt          1 {TEST01}
	File_03.txt E:\Temp\Files\File_03.txt          1 {TeST01}
#>
function Find-StringInFile
{

    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            Mandatory = $true,
            HelpMessage = "String to find")]
        [String]$Search,

        [Parameter(
            Position = 1,
            HelpMessage = "Folder where the files are stored (search is recursive)")]
        [ValidateScript( {
                if (Test-Path -Path $_)
                {
                    return $true
                }
                else
                {
                    throw "Enter a valid path!"
                }
            })]
        [String]$Path = (Get-Location),

        [Parameter(
            Position = 2,
            HelpMessage = "String must be case sensitive (Default=false)")]
        [switch]$CaseSensitive = $false
    )

    Begin
    {

    }

    Process
    {
        # Files with string to find
        $Strings = Get-ChildItem -Path $Path -Recurse | Select-String -Pattern ([regex]::Escape($Search)) -CaseSensitive:$CaseSensitive | Group-Object -Property Path

        # Go through each file
        foreach ($String in $Strings)
        {

            # Go through each group
            foreach ($Group in $String.Group)
            {
                [pscustomobject] @{
                    Filename   = $Group.Filename
                    Path       = $Group.Path
                    LineNumber = $Group.LineNumber
                    Matches    = $Group.Matches
                }
            }
        }
    }

    End
    {

    }
}