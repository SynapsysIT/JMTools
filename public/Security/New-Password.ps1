function New-Password {
    <#
     .SYNOPSIS
      Function to generate random password

     .DESCRIPTION
      Function to generate random password

     .PARAMETER Length
      Number between 2 and 200
      Default is 12

     .PARAMETER Include
      One or more of the following:
        UpperCase
        LowerCase
        Numbers
        SpecialCharacters
      Default is all 4

     .EXAMPLE
      Generate-Password

     .EXAMPLE
      Generate-Password -Length 10 -Include LowerCase,UpperCase,Numbers -Verbose

     .LINK
      https://superwidgets.wordpress.com/category/powershell/

     .NOTES
      Function by Sam Boutros
      v0.1 - 27 July 2017

    #>

        [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='Low')]
        Param(
            [Parameter(Mandatory=$false,Position=0)][ValidateRange(2,200)][Int32]$Length = 12,
            [Parameter(Mandatory=$false,Position=1)][ValidateSet('UpperCase','LowerCase','Numbers','SpecialCharacters')]
                [String[]]$Include = @('UpperCase','LowerCase','Numbers','SpecialCharacters')
        )

        Begin {}

        Process {
            Write-Verbose "Generate-Password: Input: Length  = $Length"
            Write-Verbose "Generate-Password: Input: Include = $($Include -join ', ')"

            Remove-Variable MyRange -ErrorAction SilentlyContinue | Out-Null
            $Include | % {
                if ($_ -eq 'UpperCase') {
                    $MyRange += 65..90
                    Write-Verbose 'Generate-Password: MyRange: +UpperCase'
                }
                if ($_ -eq 'LowerCase') {
                    $MyRange += 97..122
                    Write-Verbose 'Generate-Password: MyRange: +LowerCase'
                }
                if ($_ -eq 'Numbers') {
                    $MyRange += 48..57
                    Write-Verbose 'Generate-Password: MyRange: +Numbers'
                }
                if ($_ -eq 'SpecialCharacters') {
                    $MyRange += (33..47) + (58..64) + (91..96) + (123..126)
                    Write-Verbose 'Generate-Password: MyRange: +SpecialCharacters'
                }
            }
            ($MyRange | Get-Random -Count $Length | % {[char]$_}) -join ''
        }

        End {}
    }
