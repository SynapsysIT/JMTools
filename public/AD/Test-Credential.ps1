###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Test-Credential.ps1
# Autor        :  Julien Mazoyer
# Description  :  Test an authentification in AD or local context
###############################################################################################################

<#
    .SYNOPSIS
    Test an authentification in AD or local context

    .DESCRIPTION
    Test an authentification in AD or local context

    .EXAMPLE
    #AD Credentials
	PS C:\> $cred = get-credential
    PS C:\> Test-Credential $cred
    True

    .EXAMPLE
    #Local credentials
    PS C:\> $cred = get-credential
    PS C:\> Test-Credential -ComputerName SomeComputer -Credential $cred
#>

function Test-Credential
{


    [cmdletbinding(DefaultParameterSetName = 'Domain')]
    param(
        [parameter(ValueFromPipeline = $true)]
        [System.Management.Automation.PSCredential]$Credential = $( Get-Credential -Message "Please provide credentials to test" ),

        [validateset('Domain', 'Machine', 'ApplicationDirectory')]
        [string]$Context = 'Domain',

        [parameter(ParameterSetName = 'Machine')]
        [string]$ComputerName,

        [parameter(ParameterSetName = 'Domain')]
        [string]$Domain = $null
    )
    Begin
    {
        Write-Verbose "ParameterSetName: $($PSCmdlet.ParameterSetName)`nPSBoundParameters: $($PSBoundParameters | Out-String)"
        Try
        {
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement
        }
        Catch
        {
            Throw "Could not load assembly: $_"
        }

        if ($Context -eq 'ApplicationDirectory' )
        {

            $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::$Context)
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Domain')
        {
            $Context = $PSCmdlet.ParameterSetName
            $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::$Context, $Domain)
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'Machine')
        {
            $Context = $PSCmdlet.ParameterSetName
            $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::$Context, $ComputerName)
        }

    }
    Process
    {
        #Validate provided credential
        $DS.ValidateCredentials($Credential.UserName, $Credential.GetNetworkCredential().password)
    }
    End
    {
        $DS.Dispose()
    }
}