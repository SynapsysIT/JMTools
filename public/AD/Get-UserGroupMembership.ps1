###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Get-UserGroupMembership.ps1
# Autor        :  Julien Mazoyer
# Description  :  Get AD User Group Membership
###############################################################################################################

<#
    .SYNOPSIS
    Get AD User Group Membership

    .DESCRIPTION
    Get AD User Group Membership

    .EXAMPLE
    PS C:\> Get-UserGroupMembership "UserSamAccountName"
#>
function Get-UserGroupMembership
{

    Param (
        [Parameter(Mandatory = $true, ValueFromPipeLine = $true)]
        [Alias("ID", "Users", "Name")]
        [string[]]$User
    )
    Begin
    {
        Try { Import-Module ActiveDirectory -ErrorAction Stop }
        Catch { Write-Host "Unable to load Active Directory module, is RSAT installed?"; Break }
    }

    Process
    {
        ForEach ($U in $User)
        {
            $UN = Get-ADUser $U -Properties MemberOf
            $Groups = ForEach ($Group in ($UN.MemberOf))
            {
                (Get-ADGroup $Group)
            }
            $Groups = $Groups | Sort-Object
            ForEach ($Group in $Groups)
            {        
                [PSCustomObject]@{
                    Group             = $Group.Name
                    DistinguishedName = $Group.DistinguishedName
                    GroupCategory     = $Group.GroupCategory
                    GroupScope        = $Group.GroupScope
                }  
            }
        }
    }
}
