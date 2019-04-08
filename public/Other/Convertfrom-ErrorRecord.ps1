###############################################################################################################
# Language     :  PowerShell 5.0
# Filename     :  ConvertFrom-ErrorRecord.ps1
# Autor        :  Julien Mazoyer
# Description  :  Convert Powershell Error in Object to simplify explotation
###############################################################################################################

<#
      .SYNOPSIS
      Convert Powershell Error
  
      .DESCRIPTION
      Convert Powershell Error in Object to simplify explotation
  
      .EXAMPLE
      PS>C:\ ConvertFrom-ErrorRecord $Error[0]

      Exception : Le terme «get-commandnotfound» n'est pas reconnu comme nom d'applet de commande, fonction, fichier de script ou programme exécutable. Vérifiez l'orthographe du nom, ou si un chemin d'accès existe,
            vérifiez que le chemin d'accès est correct et réessayez.
      Reason    : CommandNotFoundException
      Target    : get-commandnotfound
      Script    :
      Line      : 1
      Column    : 1
#>  
function ConvertFrom-ErrorRecord
{

    [CmdletBinding(DefaultParameterSetName = "ErrorRecord")]
    param
    (
        [Management.Automation.ErrorRecord]
        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = "ErrorRecord", Position = 0)]
        $Record
    )
  
    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'ErrorRecord')
        {
            [PSCustomObject]@{
                Exception = $Record.Exception.Message
                Reason    = $Record.CategoryInfo.Reason
                Target    = $Record.CategoryInfo.TargetName
                Script    = $Record.InvocationInfo.ScriptName
                Line      = $Record.InvocationInfo.ScriptLineNumber
                Column    = $Record.InvocationInfo.OffsetInLine
            }
        }
        else
        {
            Write-Warning "$Alien"
        } 
    }
}