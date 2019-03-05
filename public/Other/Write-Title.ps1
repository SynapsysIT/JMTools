function Write-Title
{ 
    param($Message,$Color = "White",[switch]$Upper) 

    if($Upper){$Message = $Message.ToUpper()}
    [string]$TopLeft = [char]0x250C
    [string]$TopRight = [char]0x2510
    [string]$BotLeft = [char]0x2514
    [string]$BotRight = [char]0x2518
    [string]$Bar = [char]0x2502
    [string]$HorBar = [char]0x2500
    $Width = $Host.UI.RawUI.BufferSize.Width - 2
    $TopLine = "$($TopLeft)$(($HorBar * $Width))$($TopRight)"
    $BotLine = "$($BotLeft)$(($HorBar * $Width))$($BotRight)"
    
    $Blank = ' ' * (([Math]::Max(0, $Width / 2) - [Math]::Floor($Message.Length / 2)))

    Write-Host $TopLine -ForegroundColor $Color
    $Line = "{0}{1}{2}" -f $Bar,$Blank,$Message
    Write-Host $Line -ForegroundColor $Color -NoNewline
    Write-Host ("{0} {1}" -f (" " * ($Width -$Line.Length)),$Bar) -ForegroundColor $Color
    Write-Host $BotLine -ForegroundColor $Color
}