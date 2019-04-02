function Write-LineProgress {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true)][String]$Activity,
        [Parameter(Mandatory=$true)][int]$Progress
    )
    
    begin 
    {
        $HostWidth = $Host.ui.RawUI.WindowSize.Width
        [string]$FillingChar = [char]9632 
        #[string]$RemainChar = [char]183
        [string]$RemainChar = "-"
        [console]::CursorVisible = $false
    }
    
    process 
    {
        $Line = $Activity + " "
        $ProgressCounter = " $(($progress -as [string]) +"%")"
        $BarWidth = ($HostWidth - ($Line.Length + $ProgressCounter.Length) -2)
        $Progress = [math]::Round(($Progress /100) * $BarWidth)
        $Remain = $BarWidth - $Progress
        $LeftBorder = "["
        $ProgressBar = $($FillingChar * $Progress)
        $RemainBar = $($RemainChar * $Remain) 
        $RightBorder = "]"     
    }
    
    end 
    {
        Write-Host `r$Line  -NoNewline

        Write-Host $LeftBorder -NoNewline
        Write-Host $ProgressBar -NoNewline -ForegroundColor Green
        Write-Host $RemainBar -NoNewline
        Write-Host $RightBorder -NoNewline
        Write-Host $ProgressCounter -NoNewline -ForegroundColor Green
        [console]::CursorVisible = $true
    }
}


