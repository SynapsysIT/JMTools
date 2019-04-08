###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  Invoke-Supervision.ps1
# Autor        :  Julien Mazoyer
# Description  :  Show a graphical table with ping status of multiple hosts
###############################################################################################################

<#
    .SYNOPSIS
    Show a graphical table with ping status of multiple hosts

    .DESCRIPTION
    Show a graphical table with ping status of multiple hosts

    .EXAMPLE
    Invoke-Supervision "unknow.fr","localhost"

	| HOST      | STATUS | SUCCESS  | FAILURE  | ATTEMPTS  |
    | unknow.fr | DOWN   | 0,00%    | 100,00%  | 1         |
    | localhost | UP     | 100,00%  | 0,00%    | 1         |


#>
Function Invoke-Supervision
{

    #Parameter Definition
    Param
    (
        [Parameter(position = 0)][string[]]$Hosts,
        [Parameter] $ToCsv
    )
    #Funtion to make space so that formatting looks good
    Function Make-Space($l, $Maximum)
    {
        $space = ""
        $s = [int]($Maximum - $l) + 1
        1..$s | ForEach-Object {$space += " "}

        return [String]$space
    }
    #Array Variable to store length of all hostnames
    $LengthArray = @()
    $Hosts | ForEach-Object {$LengthArray += $_.length}

    #Find Maximum length of hostname to adjust column witdth accordingly
    $Maximum = ($LengthArray | Measure-object -Maximum).maximum
    $Count = $hosts.Count

    #Initializing Array objects
    $Success = New-Object int[] $Count
    $Failure = New-Object int[] $Count
    $Total = New-Object int[] $Count
    Clear-Host
    #Running a never ending loop
    while ($true)
    {

        $i = 0 #Index number of the host stored in the array
        $out = "| HOST$(Make-Space 4 $Maximum)| STATUS | SUCCESS  | FAILURE  | ATTEMPTS  |"
        $Firstline = ""
        1..$out.length| ForEach-Object {$firstline += "_"}

        #output the Header Row on the screen
        Write-Host $Firstline
        Write-host $out -ForegroundColor White -BackgroundColor Black

        $Hosts | ForEach-Object {
            $total[$i]++
            If (Test-Connection $_ -Count 1 -Quiet -ErrorAction SilentlyContinue)
            {
                $success[$i] += 1
                #Percent calclated with number of attempts made
                $SuccessPercent = $("{0:N2}" -f (($success[$i] / $total[$i]) * 100))
                $FailurePercent = $("{0:N2}" -f (($Failure[$i] / $total[$i]) * 100))

                #Print status UP in GREEN if above condition is met
                Write-Host "| $_$(Make-Space $_.Length $Maximum)| UP$(Make-Space 2 4)  | $SuccessPercent`%$(Make-Space ([string]$SuccessPercent).length 6) | $FailurePercent`%$(Make-Space ([string]$FailurePercent).length 6) | $($Total[$i])$(Make-Space ([string]$Total[$i]).length 9)|" -BackgroundColor Green -ForegroundColor Black
            }
            else
            {
                $Failure[$i] += 1


                $SuccessPercent = $("{0:N2}" -f (($success[$i] / $total[$i]) * 100))
                $FailurePercent = $("{0:N2}" -f (($Failure[$i] / $total[$i]) * 100))

                #Print status DOWN in RED if above ping failed
                Write-Host "| $_$(Make-Space $_.Length $Maximum)| DOWN$(Make-Space 4 4)  | $SuccessPercent`%$(Make-Space ([string]$SuccessPercent).length 6) | $FailurePercent`%$(Make-Space ([string]$FailurePercent).length 6) | $($Total[$i])$(Make-Space ([string]$Total[$i]).length 9)|" -BackgroundColor Red -ForegroundColor Black
            }
            $i++

        }
        Start-Sleep -Seconds 4
        Clear-Host
    }
}
