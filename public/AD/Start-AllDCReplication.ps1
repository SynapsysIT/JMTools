###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-GpResult.ps1
# Autor        :  Julien Mazoyer
# Description  :  Launch All Controllers Replication
###############################################################################################################

function Start-AllDCReplication {
    <#
    .SYNOPSIS
    Launch All Controllers Replication

    .DESCRIPTION
    Launch All Controllers Replication

    .EXAMPLE
    PS C:\>Start-AllDCReplication
#>
(Get-ADDomainController -Filter *).Name | Foreach-Object {repadmin /syncall $_ (Get-ADDomain).DistinguishedName /e /A | Out-Null}; Start-Sleep 10; Get-ADReplicationPartnerMetadata -Target "$env:userdnsdomain" -Scope Domain | Select-Object Server, LastReplicationSuccess
}
