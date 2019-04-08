###############################################################################################################
# Language     :  PowerShell 5.0
# Filename     :  Out-HTML.ps1
# Autor        :  Julien Mazoyer
# Description  :  Create a HTML Table with object send by the pipeline
###############################################################################################################

<#
    .SYNOPSIS
    Create a HTML Table with object send by the pipeline

    .DESCRIPTION
    Create a HTML Table with object send by the pipeline. 
    2 CSS Theme with colored line by string match

    .PARAMETER Search
    Add a search field for dynamic search in the file

    .PARAMETER SuccessMatch
    Color Line in green where this string is present . Add counter of success on top of the table

    .PARAMETER ErrorMatch
    Color Line in red where this string is present . Add counter of error on top of the table

    .EXAMPLE
    Get-Service | Select Name,Status | Out-HTML -ErrorMatch "Stopped" -SuccessMatch "Running" -Title "Services" -Template Dark -Open -Search
#>
function Out-HTML
{

    param
    (

        [String]$Path = "$Home\Desktop\report$(Get-Date -format yyyy-MM-dd-HH-mm-ss).html",
        [String]$Title = "PowerShell Output",
        [String]$ErrorMatch,
        [String]$WarningMatch,
        [String]$SuccessMatch,
        [ValidateSet("Dark","Light")][string]$Template = "Light",
        [Switch]$Open,
        [Switch]$Search
    )

$DarkColors = @{
    BackGround = "#222222"
    Border     = "#303030"
    Text       = "#808080"
    Error      = 'rgba(198, 40, 40,0.8)'
    Warning    = 'rgba(255, 160, 0 , 0.8)'
    Success    = 'rgba(104, 159, 56,0.8)'
}

$LightColors = @{
    BackGround = "#ecf0f1"
    Border     = "#BDBDBD"
    Text       = "#222222"
    Error      = 'rgba(198, 40, 40,0.8)'
    Warning    = 'rgba(255, 160, 0 , 0.8)'
    Success    = 'rgba(104, 159, 56,0.8)'
}
$SuccessCount = 0
$WarningCount = 0
$ErrorCount   = 0

if ($Template -eq "Light"){$Colors = $LightColors}
else {$Colors = $DarkColors}

$DateComplete = Get-Date -f "dd/MM/yy HH:mm"
#############################################################################################
$CSS = @"
<style>
    body {color:$($Colors.Text); background-color:$($Colors.BackGround);font-family: Consolas}
    table, td, th {border:0px;font-family: Consolas; Font-Size:11pt; padding:5px;border-collapse: collapse;border-bottom: 1px solid $($Colors.Border)}
    table {width: 100%}
    th { font-lifting training:bold; background-color:$($Colors.Text);color:$($Colors.BackGround); text-align:left; text-transform: uppercase;}
    td { font-color:$($Colors.Text); }
    tr:hover {background-color:$($Colors.Text);color:$($Colors.BackGround)}
    .banner {font-family: Consolas; font-size:24pt;font-weight:bold;padding:5px; color:$($Colors.Text)}
    .date {font-family: Consolas; font-size:14pt;font-weight:bold;padding:5px; color:$($Colors.Text)}
    .error {background-color:$($Colors.Error) !important; color:$($LightColors.Text)}
    .warning {background-color:$($Colors.Warning) !important; color:$($LightColors.Text)}
    .success {background-color:$($Colors.Success) !important; color:$($LightColors.Text)}
    .badge {
        padding: 1px 9px 2px;
        font-size: 20px;
        font-weight: bold;
        white-space: nowrap;
        color: #ffffff;
    }
    .badge-error {background-color: $($Colors.Error);}
    .badge-success {background-color: $($Colors.Success);}
    .badge-warning {background-color: $($Colors.Warning);}
    #myInput {
        font-family: Consolas;
        background-color: $($Colors.Background);
        color: $($Colors.Text);
        border-style: solid;
        border-color: $($Colors.Text);
        border-radius:5px;
        width: 100%;
        font-size: 20px;
        padding: 5px;
        margin-bottom: 12px;
    }
</style>
<title>$($Title)</title>
"@

$PreContent = @"
<span class="banner">$($title)</span>
<br><span class="date">Generated on $($Datecomplete)</span></p>
"@

$JSScript = @"
<script>
function myFunction() {
    var input, filter, found, table, tr, td, i, j;
    input = document.getElementById("myInput");
    filter = input.value.toUpperCase();
    table = document.getElementById("FilterTable");
    tr = table.getElementsByTagName("tr");
    for (i = 0; i < tr.length; i++) {
        td = tr[i].getElementsByTagName("td");
        for (j = 0; j < td.length; j++) {
            if (td[j].innerHTML.toUpperCase().indexOf(filter) > -1) {
                found = true;
            }
        }
        if (found) {
            tr[i].style.display = "";
            found = false;
        } else {
            tr[i].style.display = "none";
        }
    }
}
</script>

"@

$BaliseBlock =@"
<p>SUCCESS: <span class="badge badge-success">#SuccessCount</span>
WARNING: <span class="badge badge-warning">#WarningCount</span>
ERROR: <span class="badge badge-error">#ErrorCount</span></p>
"@

#############################################################################################
if ($PSBoundParameters.ContainsKey('SuccessMatch') -or $PSBoundParameters.ContainsKey('WarningMatch') -or $PSBoundParameters.ContainsKey('ErrorMatch'))
{
    $PreContent = $PreContent += $BaliseBlock
}

if ($Search)
{
    $HeadContent = $JSScript + $CSS
    $PreContent += "`n<input type=`"text`" id=`"myInput`" onkeyup=`"myFunction()`" placeholder=`"Search..`">"
}
else
{
    $HeadContent = $CSS
}




$TempHTML = $Input | ConvertTo-Html -Head $HeadContent -PreContent $PreContent |

ForEach-Object {
if($_ -like "*$($ErrorMatch)*" -and (-not [string]::IsNullOrEmpty($ErrorMatch)))         {$_ -replace "<tr>", "<tr class=error>";$ErrorCount++}
elseif($_ -like "*$($WarningMatch)*" -and (-not [string]::IsNullOrEmpty($WarningMatch))) {$_ -replace "<tr>", "<tr class=warning>";$WarningCount++}
elseif($_ -like "*$($SuccessMatch)*" -and (-not [string]::IsNullOrEmpty($SuccessMatch))) {$_ -replace "<tr>", "<tr class=success>";$SuccessCount++}
else{$_}
}

if ($Search){ $TempHTML = $TempHTML -replace "<table>",'<table id="FilterTable">'}

if ($PSBoundParameters.ContainsKey('SuccessMatch') -or $PSBoundParameters.ContainsKey('WarningMatch') -or $PSBoundParameters.ContainsKey('ErrorMatch'))
{
    $TempHTML = $TempHTML   -replace "#SuccessCount",$SuccessCount `
                            -replace "#WarningCount",$WarningCount `
                            -replace "#ErrorCount",  $ErrorCount
}

$TempHTML | Set-Content -Path $Path


    if ($Open)
    {
        Invoke-Item -Path $Path
    }
}
