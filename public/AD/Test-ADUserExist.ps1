###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Test-ADUserExist.ps1
# Autor        :  Julien Mazoyer
# Description  :  Test if a AD User exist in the AD Domain
###############################################################################################################
function Test-ADUserExists
{
	<#
    .SYNOPSIS
    Test if a AD User exist in the AD Domain

    .DESCRIPTION
    Test if a AD User exist in the AD Domain

    .EXAMPLE
	PS C:\> Test-ADUserExists j.mazoyer
	True
#>
	param(
		[Parameter(Mandatory)]
		[string]$SAMAccountName
	)
@(Get-ADUser -LDAPFilter "(samaccountname=$SAMAccountName)").Count -ne 0
}
