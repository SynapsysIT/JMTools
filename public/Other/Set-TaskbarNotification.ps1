###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Set-TaskbarNotification.ps1
# Autor        :  Julien Mazoyer
# Description  :  Create a Custom Windows Notification 
###############################################################################################################

<#    
        .SYNOPSIS
            Create Notifications for scripts in the taskbar
        
        .DESCRIPTION
            Create Notifications for scripts in the taskbar
    
        .EXAMPLE
            PS C:\> Set-TaskbarNotification -Title "Check Script Status" -Message "50 object found !" -BalloonIcon Info
    
        .EXAMPLE
            PS C:\> Set-TaskbarNotification -Message "Script Finish !"
#>
function Set-TaskbarNotification {

        [cmdletbinding()]
    Param (
    [string]$Title,
    [Parameter(mandatory=$true)][string]$Message, 
    [ValidateSet("None","Info","Warning","Error")] [string]$BalloonIcon,
    [int]$TimeoutMS
    ) 
    
    begin {
        if (!($Title)) {$Title = $host.ui.rawui.windowTitle }
        if (!($TimeoutMS)) {$TimeoutMS = 5000}
        if (!($BalloonIcon)) {$BalloonIcon = "Info"}
        [string]$IconPath='C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
        [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    }
    process {
    
        $SysTrayIcon = New-Object System.Windows.Forms.NotifyIcon 
        
        $SysTrayIcon.BalloonTipText  = $Message
        $SysTrayIcon.BalloonTipIcon  = $BalloonIcon
        $SysTrayIcon.BalloonTipTitle = $Title
        $SysTrayIcon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($IconPath)
        $SysTrayIcon.Text = "Text"
        $SysTrayIcon.Visible = $True 
    }
    end {
        $SysTrayIcon.ShowBalloonTip($Timeout)
    }
    }