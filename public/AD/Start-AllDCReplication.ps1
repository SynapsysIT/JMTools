###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-GpResult.ps1
# Autor        :  Julien Mazoyer
# Description  :  Launch All Controllers Replication
###############################################################################################################

<#
    .SYNOPSIS
    Launch All Controllers Replication

    .DESCRIPTION
    Launch All Controllers Replication

    .EXAMPLE
    PS C:\>Start-AllDCReplication
#>

function Start-AllDCReplication
{

    (Get-ADDomainController -Filter *).Name | ForEach-Object { repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null }; Start-Sleep 10; Get-ADReplicationPartnerMetadata -Target "$env:userdnsdomain" -Scope Domain | Select-Object Server, LastReplicationSuccess
}
