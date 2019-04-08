###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  ConvertFrom-Base64.ps1
# Autor        :  Julien Mazoyer
# Description  :  Convert a Base64 encoded string to a plain text string
###############################################################################################################

<#
    .SYNOPSIS
    Convert a Base64 encoded string to a plain text string

    .DESCRIPTION
    Convert a Base64 encoded string to a plain text string.

    .EXAMPLE
    ConvertFrom-Base64 "UwB1AHAAZQByACAAQwBoAGEAaQBuAGUAIAB0AG8AcAAgAHMAZQBjAHIAZQB0AA=="

    Super Chaine top secret

#>
function ConvertFrom-Base64
{

    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$true,
            Position=0,
            HelpMessage='Base64 encoded string, which is to be converted to an plain text string')]
        [String]$Text
    )

    Begin{

    }

    Process{
        try{
            # Convert Base64 to bytes
            $Bytes = [System.Convert]::FromBase64String($Text)

            # Convert Bytes to Unicode and return it
            [System.Text.Encoding]::Unicode.GetString($Bytes)
        }
        catch{
            throw
        }
    }

    End{

    }
}