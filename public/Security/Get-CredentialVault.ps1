###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-CredentialVault.ps1
# Autor        :  Julien Mazoyer
# Description  :  Retrieve credential from Windows Vault
###############################################################################################################

<#
     .SYNOPSIS
      Retrieve credential from Windows Vault

     .DESCRIPTION
      Retrieve credential from Windows Vault

     .EXAMPLE
      $Credentials = Get-CredentialVault -Username jmazoyer

#>
function Get-CredentialVault
{
    [CmdletBinding()]
    param
    (
        [string]$Username
    )

    # Load assembly
    [Windows.Security.Credentials.PasswordVault, Windows.Security.Credentials, ContentType = WindowsRuntime] | Out-Null
    $Vault = new-object Windows.Security.Credentials.PasswordVault
    $AllSavedCredentials = $Vault.RetrieveAll()

    if ($PSBoundParameters.Username)
    {
        $StoredCredential = $AllSavedCredentials | Where-Object {$_.Username -eq $Username}
        $StoredCredential.RetrievePassword()

        $ReturnedCredential = New-Object System.Management.Automation.PSCredential -ArgumentList ($StoredCredential.UserName, (ConvertTo-SecureString $StoredCredential.Password -AsPlainText -Force))

        return $ReturnedCredential
    }
    else
    {
        return $AllSavedCredentials
    }
}


