###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Update-StringInFile.ps1
# Autor        :  Julien Mazoyer Fork from BornToBeRoot (https://github.com/BornToBeRoot)
# Description  :  Replace a string in multiple files
# Repository   :  https://github.com/BornToBeRoot/PowerShell
###############################################################################################################

<#
    .SYNOPSIS
    Replace a string in one or multiple files
                 
    .DESCRIPTION         
    Replace a string in one or multiple files.
	
    Binary files (*.zip, *.exe, etc.) are not touched by this script.
	                         
    .EXAMPLE
    Update-StringInFile -Path E:\Temp\Files\ -Find "Test1" -Replace "Test2" -Verbose
       
	VERBOSE: Binary files like (*.zip, *.exe, etc...) are ignored
	VERBOSE: Total files with string to replace found: 3
	VERBOSE: Current file: E:\Temp\Files\File_01.txt
	VERBOSE: Number of strings to replace in current file: 1
	VERBOSE: Current file: E:\Temp\Files\File_02.txt
	VERBOSE: Number of strings to replace in current file: 1
	VERBOSE: Current file: E:\Temp\Files\File_03.txt
	VERBOSE: Number of strings to replace in current file: 2
#>
function Update-StringInFile
{

    [CmdletBinding(SupportsShouldProcess = $true)]
    Param(
        [Parameter(
            Position = 0,
            HelpMessage = "Folder where the files are stored (will search recursive)")]
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
            Position = 1,
            Mandatory = $true,
            HelpMessage = "String to find")]
        [String]$Find,
	
        [Parameter(
            Position = 2,
            Mandatory = $true,
            HelpMessage = "String to replace")]
        [String]$Replace,

        [Parameter(
            Position = 3,
            HelpMessage = "String must be case sensitive (Default=false)")]
        [switch]$CaseSensitive = $false
    )

    Begin
    {

        function Test-IsFileBinary
        {
            [CmdletBinding()]
            [OutputType('System.Boolean')]
            Param(
                [Parameter(
                    Position = 0,
                    Mandatory = $true,
                    HelpMessage = "Path to file which should be checked")]
                [ValidateScript( {
                        if (Test-Path -Path $_ -PathType Leaf)
                        {
                            return $true
                        }
                        else 
                        {
                            throw "Enter a valid file path!"	
                        }
                    })]
                [String]$FilePath
            )

            Begin
            {
		
            }

            Process
            {
                # Encoding variable
                $Encoding = [String]::Empty

                # Get the first 1024 bytes from the file
                $ByteCount = 1024
        		
                $ByteArray = Get-Content -Path $FilePath -Encoding Byte -TotalCount $ByteCount

                if ($ByteArray.Count -ge $ByteCount)
                {
                    Write-Verbose -Message "Could only read $($ByteArray.Count)/$ByteCount Bytes. File "
                }
      
                if (($ByteArray.Count -ge 4) -and (("{0:X}{1:X}{2:X}{3:X}" -f $ByteArray) -eq "FFFE0000"))
                {
                    Write-Verbose -Message "UTF-32 detected!"
                    $Encoding = "UTF-32"
                }
                elseif (($ByteArray.Count -ge 4) -and (("{0:X}{1:X}{2:X}{3:X}" -f $ByteArray) -eq "0000FEFF"))
                {
                    Write-Verbose -Message "UTF-32 BE detected!"
                    $Encoding = "UTF-32 BE"
                }
                elseif (($ByteArray.Count -ge 3) -and (("{0:X}{1:X}{2:X}" -f $ByteArray) -eq "EFBBBF"))
                {
                    Write-Verbose -Message "UTF-8 detected!"
                    $Encoding = "UTF-8"
                }
                elseif (($ByteArray.Count -ge 2) -and (("{0:X}{1:X}" -f $ByteArray) -eq "FFFE"))
                {
                    Write-Verbose -Message "UTF-16 detected!"
                    $Encoding = "UTF-16"
                }
                elseif (($ByteArray.Count -ge 2) -and (("{0:X}{1:X}" -f $ByteArray) -eq "FEFF"))
                {
                    Write-Verbose "UTF-16 BE detected!"
                    $Encoding = "UTF-16 BE"
                }

                if (-not([String]::IsNullOrEmpty($Encoding)))
                {
                    Write-Verbose -Message "File is text encoded!"
                    return $false
                }

                # So now we're done with Text encodings that commonly have '0's
                # in their byte steams.  ASCII may have the NUL or '0' code in
                # their streams but that's rare apparently.

                # Both GNU Grep and Diff use variations of this heuristic

                if ($byteArray -contains 0 )
                {
                    Write-Verbose -Message "File is a binary!"
                    return $true
                }

                Write-Verbose -Message "File should be ASCII encoded!"
                return $false
            }

            End
            {
		
            }
        }

    }

    Process
    {
        Write-Verbose -Message "Binary files like (*.zip, *.exe, etc...) are ignored"

        $Files = Get-ChildItem -Path $Path -Recurse | Where-Object { ($_.PSIsContainer -eq $false) -and ((Test-IsFileBinary -FilePath $_.FullName) -eq $false) } | Select-String -Pattern ([regex]::Escape($Find)) -CaseSensitive:$CaseSensitive | Group-Object Path 
		
        Write-Verbose -Message "Total files with string to replace found: $($Files.Count)"

        # Go through each file
        foreach ($File in $Files)
        {
            Write-Verbose -Message "File:`t$($File.Name)"
            Write-Verbose -Message "Number of strings to replace in current file:`t$($File.Count)"
    
            if ($PSCmdlet.ShouldProcess($File.Name))
            {
                try
                {	
                    # Replace string
                    if ($CaseSensitive)
                    {
                        (Get-Content -Path $File.Name) -creplace [regex]::Escape($Find), $Replace | Set-Content -Path $File.Name -Force
                    }
                    else
                    {
                        (Get-Content -Path $File.Name) -replace [regex]::Escape($Find), $Replace | Set-Content -Path $File.Name -Force
                    }
                }
                catch
                {
                    Write-Error -Message "$($_.Exception.Message)" -Category InvalidData
                }
            }
        }
    }

    End
    {

    }
}