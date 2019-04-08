###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Save-CredentialVault.ps1
# Autor        :  Julien Mazoyer
# Description  :  Save credential to Windows Vault
###############################################################################################################

<#
     .SYNOPSIS
      Save credential to Windows Vault

     .DESCRIPTION
      Retrieve credential to Windows Vault

     .EXAMPLE
      $Credentials = Get-Credential
      Save-CredentialVault -Credentials $Credentials -Description "Compte Enterprise Admin"

#>
function Save-CredentialVault
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
        [pscredential]$Credentials,
        [Parameter(Mandatory = $false)]
		[string]$Description = "PSCredentials"
	)

    # Load assembly
    [Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime] | Out-Null
    $Vault = new-object Windows.Security.Credentials.PasswordVault


    [string]$Resource = $Description

    # Convert and store in vault
    $CredObject = New-Object Windows.Security.Credentials.PasswordCredential -ArgumentList ($Resource, $Credentials.UserName,$Credentials.GetNetworkCredential().Password)
    $vault.Add($CredObject)

}