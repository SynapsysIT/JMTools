function ConvertFrom-CredentialFileToCredential
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateScript({ test-path $_ })]
		[ValidateNotNullOrEmpty()]
		[string]$Path
	)

	$rawData = Get-Content $Path
	$xmlstring = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR((($rawData | ConvertTo-SecureString))))

	$type = [PSObject].Assembly.GetType('System.Management.Automation.Deserializer')
	$ctor = $type.GetConstructor('instance,nonpublic', $null, @([xml.xmlreader]), $null)
	$sr = New-Object System.IO.StringReader $xmlString
	$xr = New-Object System.Xml.XmlTextReader $sr
	$deserializer = $ctor.Invoke($xr)
	$done = $type.GetMethod('Done', [System.Reflection.BindingFlags]'nonpublic,instance')
	while (!$type.InvokeMember("Done", "InvokeMethod,NonPublic,Instance", $null, $deserializer, @()))
	{
		try
		{
			$credentialData = $type.InvokeMember("Deserialize", "InvokeMethod,NonPublic,Instance", $null, $deserializer, @())
		}
		catch
		{
			Write-Warning "Could not deserialize ${string}: $_"
		}
	}
	$xr.Close()
	$sr.Dispose()

	$encryptedPassword = $credentialData.password | ConvertTo-SecureString
	New-Object System.Management.Automation.PSCredential($($credentialData.username), $($encryptedPassword))
}