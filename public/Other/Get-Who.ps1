﻿###############################################################################################################
# Language     :  PowerShell 5.0
# Filename     :  Get-Who.ps1
# Autor        :  Julien Mazoyer
# Description  :  Get PowerShell session information
###############################################################################################################

<#
    .SYNOPSIS
    Get PowerShell session information
#>
Function Get-Who {

      [CmdletBinding()]
      Param(
        [switch]$AsString
      )
  
  if ($PSVersionTable.PSEdition -eq "desktop" -OR $PSVersionTable.OS -match "Windows") {
        
          #get some basic information about the operating system
          $cimos = Get-CimInstance win32_operatingsystem -Property Caption, Version,OSArchitecture
          $os = "$($cimos.Caption) [$($cimos.OSArchitecture)]"
          $osver = $cimos.Version
  
          #determine the current user so we can test if the user is running in an elevated session
          $current = [Security.Principal.WindowsIdentity]::GetCurrent()
          $principal = [Security.Principal.WindowsPrincipal]$current
          $Elevated = $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
          $user = $current.Name
          $computer = $env:COMPUTERNAME
      }
      else {
       #non-Windows values
        $os = $PSVersionTable.OS
        $lsb = lsb_release -d
        $osver =   ($lsb -split ":")[1].Trim()
        $elevated = "NA"
        $user = $env:USER
        $computer = $env:NAME
      }
  
  
      #object properties will be displayed in the order they are listed here
      $who = [pscustomObject]@{ 
          User            = $user
          Elevated        = $elevated
          Computername    = $computer
          OperatingSystem = $os
          OSVersion       = $osver
          PSVersion       = $PSVersionTable.PSVersion.ToString()
          Edition         = $PSVersionTable.PSEdition
          PSHost          = $host.Name
          WSMan           = $PSVersionTable.WSManStackVersion.ToString()
          ExecutionPolicy = (Get-ExecutionPolicy)
          Culture         = $host.CurrentCulture
      }
  
      if ($AsString) {
        $who | Out-String
      }
      else {
        $who
      }
  }