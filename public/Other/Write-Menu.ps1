###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Write-Menu.ps1
# Autor        :  Julien Mazoyer
# Description  :  Create Interactive Menu , Navigate with Arrrows Keys
###############################################################################################################

<#
    .SYNOPSIS
    Create Menu with selection by arrows keys

    .DESCRIPTION
    Create Menu with selection by arrows keys and return selection.

    .PARAMETER Multiselect

    Make possible to choose multiple items. Return as an array

    .EXAMPLE
    $TopProcess = Get-Process | Sort-Object CPU | Select-Object -First 10

    $Select = Write-Menu -menuItems $TopProcess.Name -Title "Selectionnez le processus a arreter:"

    Selectionnez le processus a arreter:
    ────────────────────────────────
        > svchost
        svchost
        svchost
        svchost
        Registry
        OfficeClickToRun
        NvTelemetryContainer
        OriginWebHelperService
        svchost
        PnkBstrA

    Stop-Process $Select

    .EXEMPLE

    Write-Menu -menuItems @(Get-ChildItem -File) -Title "Selectionnez les fichiers a supprimer" -Multiselect

    Selectionnez les fichiers a supprimer
    ─────────────────────────────────────
        [ ] CheckDNSPRODAD.ps1
        [ ] DISM Demo.ps1
        [ ] Log-20190405-1603.log
        [x] Log-20190405-1608.log
        [x] Log-20190407-1231.log
        [x] PROD_PostBascule.log
      > [x] PROD_PreBascule.log
        [ ] Report.html
 #>
function Write-Menu
{
    param ([array]$menuItems, [switch]$ReturnIndex = $false, [switch]$Multiselect, [string]$Color = "Green", [string]$Title,[switch]$Help)

    #ScriptBlock génération du menu
    [scriptblock]$SB_DrawMenu = {
        param ($menuItems, $menuPosition, $Multiselect, $selection, [string]$Color = "Green", $Title)

        $ConsoleWidth = $Host.ui.RawUI.WindowSize.Width
        $Width = $ConsoleWidth - 2
        #$Width = ($menuItems.Name | Sort-object Length -Descending | Select-Object -First 1).Length + 20
        if ($Title.Length -gt $Width){$Width = $Title.Length}

        [string]$TopLeft = [char]0x250C
        [string]$TopRight = [char]0x2510
        [string]$BotLeft = [char]0x2514
        [string]$BotRight = [char]0x2518
        [string]$Bar = [char]0x2502
        [string]$HorBar = [char]0x2500
        [string]$Cursor = [char]0x25ba
        [string]$TitleLeftBar = [char]0x251C
        [string]$TitleRightBar = [char]0x2524


        $TopLine = "$($TopLeft)$($HorBar * $Width)$($TopRight)"
        $BotLine = "$($BotLeft)$(($HorBar * $Width))$($BotRight)"

        Write-Host ""
        if ($Title)
        {

            Write-Host "$($Title + $(" " * $($Width - $($Title.Length))))" -ForegroundColor $Color
            Write-Host $($HorBar * $Title.Length) -ForegroundColor $Color
        }
        else
        {

        }

        $l = $menuItems.length
        for ($i = 0; $i -le $l; $i++)
        {
            if ($menuItems[$i] -ne $null)
            {
                $item = $menuItems[$i]
                if ($Multiselect)
                {
                    if ($selection -contains $i)
                    {
                        $item = '[x] ' + $item
                    }
                    else
                    {
                        $item = '[ ] ' + $item
                    }
                }
                if ($i -eq $menuPosition)
                {
                    $Line = " > $($item)"
                    Write-Host "$Line" -ForegroundColor $Color
                }
                else
                {
                    $Line = "   $($item)"
                    Write-Host "$Line"
                }
            }
        }
        if ($Help)
        {
            if ($Multiselect)
            {
                Write-Host ""
                Write-Host "Select - [SPACE] | Change - [UP/DOWN]" -ForegroundColor $Color
            }
            else
            {
                Write-Host ""
                Write-Host "Select - [ENTER] | Change - [UP/DOWN]" -ForegroundColor $Color
            }
        }
    
    }

    [scriptblock]$SB_ToggleSelection = {
        param ($pos, [array]$selection)
        if ($selection -contains $pos)
        { 
            $result = $selection | where {$_ -ne $pos}
        }
        else
        {
            $selection += $pos
            $result = $selection
        }
        $result
    }


    $vkeycode = 0
    $pos = 0
    $selection = @()
    $cur_pos = [System.Console]::CursorTop
    [console]::CursorVisible = $false #prevents cursor flickering
    if ($menuItems.Length -gt 0)
    {
        & $SB_DrawMenu -menuItems $menuItems -menuPosition $pos $Multiselect -selection $selection -Color $Color -Title $Title
        While ($vkeycode -ne 13 -and $vkeycode -ne 27)
        {
            $press = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown")
            $vkeycode = $press.virtualkeycode
            If ($vkeycode -eq 38 -or $press.Character -eq 'k') {$pos--}
            If ($vkeycode -eq 40 -or $press.Character -eq 'j') {$pos++}
            If ($press.Character -eq ' ') { $selection = & $SB_ToggleSelection -pos $pos -selection $selection }
            if ($pos -lt 0) {$pos = 0}
            If ($vkeycode -eq 27) {$pos = $null }
            if ($pos -ge $menuItems.length) {$pos = $menuItems.length - 1}
            if ($vkeycode -ne 27)
            {
                [System.Console]::SetCursorPosition(0, $cur_pos)
                & $SB_DrawMenu -menuItems $menuItems -menuPosition $pos $Multiselect -selection $selection -Color $Color -Title $Title
                #DrawMenu  $menuItems $pos $Multiselect $selection
            }
        }
    }
    else 
    {
        $pos = $null
    }
    [console]::CursorVisible = $true

    if ($ReturnIndex -eq $false -and $pos -ne $null)
    {
        if ($Multiselect)
        {
            return $menuItems[$selection]
        }
        else
        {
            return $menuItems[$pos]
        }
    }
    else 
    {
        if ($Multiselect)
        {
            return $selection
        }
        else
        {
            return $pos
        }
    }
}
