###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Install-Rsat.ps1
# Autor        :  Julien Mazoyer
# Description  :  Downloads and installs RSAT
###############################################################################################################

<#
      .SYNOPSIS
      Downloads and installs RSAT (Windows Remote Server Admin tools).

      .DESCRIPTION
      Downloads and installs RSAT (Windows Remote Server Admin tools).
      Requires -RunAsAdministrator.

      .EXAMPLE
      Install-Rsat
#>
function Install-Rsat {


  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWMICmdlet', '')]
  [CmdletBinding(ConfirmImpact = 'Medium')]
  [Alias('InstallRsat')]
  [OutputType([void])]

  param
  (
  )

  # Install RSAT on Server
  $OperatingSystem = Get-WmiObject -Class Win32_OperatingSystem
  if($OperatingSystem.Name -like '*Windows Server*') {
    Add-WindowsFeature RSAT -IncludeAllSubFeature
    break
  }
  
  # Check architecture
  if($ENV:PROCESSOR_ARCHITECTURE -eq 'AMD64') {
    Write-Verbose -Message 'x64 Architecture'
    $Uri = 'https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/WindowsTH-RSAT_WS2016-x64.msu'
  }
  else{
    Write-Verbose -Message 'x86 Architecture'
    $Uri = 'https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/WindowsTH-RSAT_WS2016-x86.msu'
  }
  
  # Set download path
  $PathDownload = ($env:USERPROFILE) + '\Downloads\' + ($Uri.Split('/')[-1])
  
  # Downloading file using Invoke-WebRequest
  Write-Verbose -Message 'Downloading RSAT file not using IE and BITS engine'
  Invoke-WebRequest -Uri $Uri -OutFile $PathDownload -UseBasicParsing
  
  $SignatureCheck = Get-AuthenticodeSignature -FilePath $PathDownload
  if($SignatureCheck.Status -ne 'valid') {
    Write-Error -Message 'Download file error. Exiting...'    
    break
  }
  else {
    Write-Verbose -Message 'File signature correct.'
  }
  
  # install RSAT
  $WusaArguments = $PathDownload + ' /quiet'
  $WusaBin = "$env:windir\System32\wusa.exe"
    
  if( (Test-Path -Path $PathDownload) -and (Test-Path -Path $WusaBin) ) {
    'Installing RSAT - please wait'
    Start-Process -FilePath $WusaBin -ArgumentList $WusaArguments -Verb RunAs -Wait -PassThru
  }
  else {
    Write-Error -Message "Missing $PathDownload or $WusaBin"
  }
}
