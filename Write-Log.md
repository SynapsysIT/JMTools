---
external help file: JMTools-help.xml
Module Name: JMTools
online version:
schema: 2.0.0
---

# Write-Log

## SYNOPSIS
Function de Log

## SYNTAX

### Message
```
Write-Log -Message <String> [-Level <String>] [-Step] [-Color <String>] -LogFile <String> [<CommonParameters>]
```

### StartLog
```
Write-Log [-StartLog] [-Color <String>] -LogFile <String> [<CommonParameters>]
```

### EndLog
```
Write-Log [-EndLog] [-Color <String>] -LogFile <String> [<CommonParameters>]
```

## DESCRIPTION
Function pour logger dans la console et dans un fichier

## EXAMPLES

### EXEMPLE 1
```
# D?marrer le script
```

Write-Log -StartLog -LogFile $LogFile

Write-Log -Level Error -Message "Message d'erreur" -LogFile $LogFile
Write-Log -Level Warn -Message "Message d'avertissement" -LogFile $LogFile
Write-Log -Level Info -Message "Message d'info" -LogFile $LogFile

#Ecrire le r?sultat d'une ?tape 
Write-Log -Step -Message "OK" -LogFile $LogFile

#Finir le script
Write-Log -Endlog -LogFile $LogFile

#Definir le param?tre LogFile par defaut :

$LogFile = 'C:\logs\mylogfile.log'
$PSDefaultParameterValues = @{ 'Write-Log:LogFile'   = $LogFile}

## PARAMETERS

### -Message
{{Fill Message Description}}

```yaml
Type: String
Parameter Sets: Message
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Level
{{Fill Level Description}}

```yaml
Type: String
Parameter Sets: Message
Aliases:

Required: False
Position: Named
Default value: Info
Accept pipeline input: False
Accept wildcard characters: False
```

### -Step
{{Fill Step Description}}

```yaml
Type: SwitchParameter
Parameter Sets: Message
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -StartLog
{{Fill StartLog Description}}

```yaml
Type: SwitchParameter
Parameter Sets: StartLog
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -EndLog
{{Fill EndLog Description}}

```yaml
Type: SwitchParameter
Parameter Sets: EndLog
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Color
{{Fill Color Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Green
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogFile
{{Fill LogFile Description}}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
##################################################################
Author:     Julien Mazoyer
Name:       Write-Log

Date        
10/04/2018      Creation
##################################################################

## RELATED LINKS
