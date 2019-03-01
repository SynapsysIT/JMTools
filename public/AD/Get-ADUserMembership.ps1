#requires -version 2
<#
.SYNOPSIS
  Lister l'appartenance à un groupe d'un utilisateur

.PARAMETER User

.NOTES
    # =======================================================
    # NAME: Get-UserGroupMembership.ps1
    # AUTHOR: MAZOYER Julien
    # DATE: DD/MM/YYYY
    # VERSION 1.0
    # =======================================================
#>
function Get-UserGroupMembership
{
    Param (
    [Parameter(Mandatory=$true,ValueFromPipeLine=$true)]
    [Alias("ID","Users","Name")]
    [string[]]$User
)
Begin {
    Try { Import-Module ActiveDirectory -ErrorAction Stop }
    Catch { Write-Host "Unable to load Active Directory module, is RSAT installed?"; Break }
}

Process {
    ForEach ($U in $User)
    {   $UN = Get-ADUser $U -Properties MemberOf
        $Groups = ForEach ($Group in ($UN.MemberOf))
        {   (Get-ADGroup $Group).Name
        }
        $Groups = $Groups | Sort
        ForEach ($Group in $Groups)
        {        
           [PSCustomObject]@{
               Group = $Group
           }  
        }
    }
}
}
