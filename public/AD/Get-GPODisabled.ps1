function Get-GPODisabled {
    [cmdletbinding()]
    param (
    )
    try {
        Write-Verbose -Message "Importing GroupPolicy module"
        Import-Module GroupPolicy -ErrorAction Stop
    }
    catch {
        Write-Error -Message "GroupPolicy Module not found. Make sure RSAT (Remote Server Admin Tools) is installed"
        exit
    }
    $DisabledGPO = New-Object System.Collections.ArrayList
    try {
        Write-Verbose -Message "Importing GroupPolicy Policies"  
        $GPOs = Get-GPO -All  
        Write-Verbose -Message "Found '$($GPOs.Count)' policies to check"
    }
    catch {
        Write-Error -Message "Can't Load GPO's Please make sure you have connection to the Domain Controllers"
        exit
    }
    $Return = ForEach ($gpo  in $GPOs) { 
        Write-Verbose -Message "Checking '$($gpo.DisplayName)' status"
        switch ($gpo.GpoStatus) {
            "ComputerSettingsDisabled" {$DisabledGPO = "Computer Settings"}
            "UserSettingsDisabled" {$DisabledGPO = "User Settings"}
            "AllSettingsDisabled" {$DisabledGPO = "All Settings"}
        }

        [PSCustomObject]@{
            Name = $GPO.DisplayName
            Status = $DisabledGPO
        }

    }

    return $Return  
}