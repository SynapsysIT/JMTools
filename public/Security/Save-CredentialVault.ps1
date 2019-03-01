function Save-CredentialVault
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
        [pscredential]$Credential,
        [Parameter(Mandatory = $false)]
		[string]$Description = "PSCredentials"
	)

    # Load assembly
    [Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime] | Out-Null
    $Vault = new-object Windows.Security.Credentials.PasswordVault


    [string]$Resource = $Description

    # Convert and store in vault
    $CredObject = New-Object Windows.Security.Credentials.PasswordCredential -ArgumentList ($Resource, $Credential.UserName,$Credential.GetNetworkCredential().Password)
    $vault.Add($CredObject)

}