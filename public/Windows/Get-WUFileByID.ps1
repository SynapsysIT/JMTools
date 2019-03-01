function Get-WUFileByID {

    <# MIT License

    #>

    #Requires -Version 3.0

    Param (
        [Parameter(ParameterSetName = 'Default', Position = 0, Mandatory)]
        [Parameter(ParameterSetName = 'ByKBLinksOnly', Position = 1, Mandatory)]
        [string]$KB,
        [Parameter(ParameterSetName = 'ByGUID', Position = 0, Mandatory)]
        [Parameter(ParameterSetName = 'ByGUIDLinksOnly', Position = 0, Mandatory)]
        [guid]$GUID,
        [Parameter(ParameterSetName = 'Default', Position = 1, Mandatory)]
        [Parameter(ParameterSetName = 'ByKBLinksOnly', Position = 1, Mandatory)]
        [string]$SearchCriteria,
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByKBLinksOnly')]
        [ValidateSet('Product', 'Title', 'ProductAndTitle')]
        [string]$SearchType = 'ProductAndTitle',
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByKBLinksOnly')]
        [ValidateSet('x86', 'x64')]
        [string]$Platform,
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByGUID')]
        [ValidateScript( {Test-Path $_ -PathType 'Container'})]
        [string]$DestinationFolder = '.\',
        [Parameter(ParameterSetName = 'ByKBLinksOnly', Mandatory)]
        [Parameter(ParameterSetName = 'ByGUIDLinksOnly', Mandatory)]
        [switch]$LinksOnly,
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByGUID')]
        [Parameter(ParameterSetName = 'ByKBLinksOnly')]
        [Parameter(ParameterSetName = 'ByGUIDLinksOnly')]
        [switch]$ForceSSL,
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByKBLinksOnly')]
        [string]$SearchPageTemplate = 'https://www.catalog.update.microsoft.com/Search.aspx?q={0}',
        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ByGUID')]
        [Parameter(ParameterSetName = 'ByKBLinksOnly')]
        [Parameter(ParameterSetName = 'ByGUIDLinksOnly')]
        [string]$DownloadPageTemplate = 'https://www.catalog.update.microsoft.com/DownloadDialog.aspx?updateIDs=%5B%7B%22size%22%3A0%2C%22languages%22%3A%22%22%2C%22uidInfo%22%3A%22{0}%22%2C%22updateID%22%3A%22{0}%22%7D%5D&updateIDsBlockedForImport=&wsusApiPresent=&contentImport=&sku=&serverName=&ssl=&portNumber=&version='
    )

    if($PSVersionTable.PSEdition -eq 'Core')
    {
        throw 'The script uses Internet Explorer engine and, therefore, requires the Desktop edition of PowerShell'
    }

    function NewCustomErrorRecord {
        Param (
            [Parameter(Mandatory)]
            [System.Management.Automation.ErrorRecord]$ErrorRecord,
            [Parameter(Mandatory)]
            [string]$Message
        )

        @{
            'Message'            = $Message
            'Category'           = $ErrorRecord.CategoryInfo.Category
            'ErrorId'            = $ErrorRecord.FullyQualifiedErrorId
            'TargetObject'       = $ErrorRecord.TargetObject
            'CategoryReason'     = $ErrorRecord.CategoryInfo.Reason
            'CategoryActivity'   = $ErrorRecord.CategoryInfo.Activity
            'CategoryTargetName' = $ErrorRecord.CategoryInfo.TargetName
            'CategoryTargetType' = $ErrorRecord.CategoryInfo.TargetType
            'Exception'          = (New-Object -TypeName 'System.Management.Automation.RuntimeException' -ArgumentList ($Message, $ErrorRecord.Exception, $ErrorRecord.Exception.ErrorRecord))
        }
    }

    function DownloadWUFile {
        Param (
            [Parameter(Mandatory)]
            [string]$URL,
            [Parameter(Mandatory)]
            [ValidateScript( {Test-Path $_ -PathType 'Container'})]
            [string]$DestinationFolder,
            [Parameter(Mandatory)]
            [string]$FileName,
            [string]$KB,
            [string]$GUID
        )

        $FullFileName = Join-Path -Path $DestinationFolder -ChildPath $FileName
        try {
            Invoke-WebRequest -Uri $URL -OutFile $FullFileName
        }
        catch {
            $Params = NewCustomErrorRecord -Message ('Failed to download {0}' -f $URL) -ErrorRecord $_
            Write-Error @Params
            return
        }
        if (Test-Path -Path $FullFileName -PathType Leaf) {
            Get-Item -Path $FullFileName
        }
        else {
            if ($GUID) {
                Write-Error -Message ('Could not write a file for GUID {0} to a location {1}' -f $GUID, $FullFileName)
                return
            }
            else {
                Write-Error -Message ('Could not write a file for KB {0} to a location {1}' -f $KB, $FullFileName)
                return
            }
            exit
        }
    }

    function RewriteURLtoHTTPS {
        Param (
            [Parameter(Mandatory)]
            [string[]]$URL
        )

        foreach ($Item in $URL) {
            if ($Item -match '^https*:\/\/(.+)$') {
                'https://{0}' -f $Matches[1]
            }
        }
    }

    function ParseKBDownloadLinksFromText {
        Param (
            [Parameter(Mandatory)]
            $Text,
            [guid]$GUID,
            [string]$KB,
            [switch]$ForceSSL
        )

        foreach ($Item in ((Select-String -InputObject $Text -Pattern "downloadInformation\[\d\]\.files\[\d\]\.url\s*=\s*'.+'\s*;" -AllMatches).Matches)) {
            # There could be several files for a single update - gotta catch them all!
            if ($Item -match "downloadInformation\[\d\]\.files\[\d\]\.url\s*=\s*'(.+)'\s*;") {
                if ($ForceSSL) {
                    try {
                        RewriteURLtoHTTPS -URL $Matches[1]
                    }
                    catch {
                        $Params = NewCustomErrorRecord -Message ('Failed invoking RewriteURLtoHTTPS for URL {0}' -f $URL) -ErrorRecord $_
                        Write-Error @Params
                        return
                    }
                }
                else {
                    $Matches[1]
                }
            }
            else {
                if ($KB) {
                    Write-Error -Message ('Could not extract a download link from the element {0} for KB {1}' -f $Item, $KB)
                    return
                }
                else {
                    Write-Error -Message ('Could not extract a download link from the element {0} for GUID {1}' -f $Item, $GUID)
                    return
                }
            }
        }

    }
    function ParseKBDownloadLinksFromHTML {
        Param (
            [Parameter(Mandatory)]
            [Microsoft.PowerShell.Commands.HtmlWebResponseObject]$HTMLObject,
            [guid]$GUID,
            [string]$KB,
            [switch]$ForceSSL
        )

        $KBCatalogDownloadPageScripts = $HTMLObject.ParsedHtml.getElementsByTagName('script') # The actual update links are in a JavaScript array, grabbing all the scripts from the page.
        $KBDownloadScriptText = ($KBCatalogDownloadPageScripts | Where-Object -FilterScript {$_.innerHTML -Like '*var downloadInformation = new Array();*'}).innerHTML # Then we finding the one containing the download links.

        try {
            ParseKBDownloadLinksFromText -Text $KBDownloadScriptText -KB $KB -GUID $GUID -ForceSSL:$ForceSSL
        }
        catch {
            $Params = NewCustomErrorRecord -Message ('Failed invoking ParseKBDownloadLinksFromText for KB {0} and GUID {1}' -f $KB, $GUID) -ErrorRecord $_
            Write-Error @Params
            return
        }
    }

    function GetKBDownloadLinksByGUID {
        Param (
            [Parameter(Mandatory)]
            [string]$DownloadPageTemplate,
            [Parameter(Mandatory)]
            [guid]$GUID,
            [string]$KB,
            [switch]$ForceSSL
        )

        $URL = $DownloadPageTemplate -f $GUID

        try {
            $KBCatalogDownloadPage = Invoke-WebRequest -Uri $URL
        }
        catch {
            $Params = NewCustomErrorRecord -Message ('Failed to download URL {0}' -f $URL) -ErrorRecord $_
            Write-Error @Params
            return
        }

        try {
            ParseKBDownloadLinksFromHTML -HTMLObject $KBCatalogDownloadPage -KB $KB -GUID $GUID -ForceSSL:$ForceSSL
        }
        catch {
            $Params = NewCustomErrorRecord -Message ('Failed invoking ParseKBDownloadLinksFromHTML for KB {0} and GUID {1}' -f $KB, $GUID) -ErrorRecord $_
            Write-Error @Params
            return
        }
    }

    if ($KB) {
        function FindTableColumnNumber {
            Param (
                [Parameter(Mandatory)]
                $Columns,
                [Parameter(Mandatory)]
                [string]$Pattern
            )

            $Counter = 0

            foreach ($Column in $Columns) {
                if ($Column.InnerHTML -like $Pattern) {
                    break
                }
                $Counter++
            }

            $Counter
        }

        Write-Verbose -Message ('Downloading KB {0}' -f $KB)
        $URL = $SearchPageTemplate -f $KB

        try {
            $KBCatalogPage = Invoke-WebRequest -Uri $URL
        }
        catch {
            $Params = NewCustomErrorRecord -Message ('Failed to download URL {0} for KB {1}' -f $URL, $KB) -ErrorRecord $_
            Write-Error @Params
            return
        }

        if ($KBCatalogPage) {
            try {
                $Rows = $KBCatalogPage.ParsedHtml.getElementById('ctl00_catalogBody_updateMatches').getElementsByTagName('tr') # This line detects the main table which contains updates data.
            }
            catch {
                $Params = NewCustomErrorRecord -Message ('Unable to parse a download page for KB {0}' -f $KB) -ErrorRecord $_
                Write-Error @Params
                return
            }
        }
        else {
            Write-Error -Message ('Failed to download a download page for KB {0}' -f $KB)
            return
        }

        if (-not $Rows) {
            Write-Error -Message ('No rows have been returned from a download page for KB {0}' -f $KB)
            return
        }

        $HeaderRow = $null
        foreach ($Row in $Rows) {
            if ($Row.id -eq 'headerRow') {
                if (-not $HeaderRow) {
                    $HeaderRow = $Row
                }
                else {
                    Write-Error -Message ('Multiple header rows returned for KB {0}' -f $KB)
                    return
                }
            }
        }

        if ($HeaderRow) {
            $Columns = $HeaderRow.getElementsByTagName('td')
        }
        else {
            Write-Error -Message ('Could not find a header row for KB {0}' -f $KB)
            return
        }

        try {
            $DateColumnNumber = FindTableColumnNumber -Columns $Columns -Pattern '*<SPAN>Last Updated</SPAN>*' # Finding a column where the update release date is stored.
            $ProductColumnNumber = FindTableColumnNumber -Columns $Columns -Pattern '*<SPAN>Products</SPAN>*' # Finding a column where the product name is stored.
            $TitleColumnNumber = FindTableColumnNumber -Columns $Columns -Pattern '*<SPAN>Title</SPAN>*' # Finding a column where update title and ID are stored.
        }
        catch {
            Write-Error -Message ('Failed invoking FindTableColumnNumber for KB {0}' -f $KB) -Exception $_.Exception
            return
        }

        $DataRows = @()
        foreach ($Row in $Rows) {
            if ($Row.id -ne 'headerRow') {
                $DataRows += $Row
            }
        }

        if (-not $DataRows) {
            Write-Error -Message ('No data rows have been found for KB {0}' -f $KB)
            return
        }

        $CandidateRows = @()
        foreach ($Row in $DataRows) {
            # There could be not one but several rows matching the pattern. We should process them all. $CandidateRows contains such rows.
            if ($SearchType -eq 'Product' -or $SearchType -eq 'ProductAndTitle') {
                if ($Row.getElementsByTagName('td')[$ProductColumnNumber].innerHTML -like ('*{0}*' -f $SearchCriteria)) {
                    $CandidateRows += $Row
                }
            }
            if ($SearchType -eq 'Title' -or $SearchType -eq 'ProductAndTitle') {
                if ($Row.getElementsByTagName('td')[$TitleColumnNumber].innerHTML -like ('*{0}*' -f $SearchCriteria)) {
                    $CandidateRows += $Row
                }
            }
        }

        if ($CandidateRows) {
            if ($Platform) {
                $CandidateRowsTemp = @()
                foreach ($Row in $CandidateRows) {
                    if ($Row.getElementsByTagName('td')[$TitleColumnNumber].innerHTML -like ('*{0}*' -f $Platform)) {
                        $CandidateRowsTemp += $Row
                    }
                }
                $CandidateRows = $CandidateRowsTemp
            }
        }

        if (-not $CandidateRows) {
            Write-Error -Message ('No candidate rows have been found for KB {0}' -f $KB)
            return
        }

        $RowNumber = 0
        $ReleaseDate = New-Object -TypeName DateTime -ArgumentList @(1, 1, 1) # The lowest possible date in .NET

        foreach ($Row in $CandidateRows) {
            # Here we are looking for a row with the most recent release date.
            if ($ReleaseDate -lt [datetime]::ParseExact($Row.getElementsByTagName('td')[$DateColumnNumber].innerHTML.Trim(), 'm/d/yyyy', $null)) {
                # We assume that MS never publishes several versions of an update on the same day.
                break
            }
            $RowNumber++
        }

        if ($CandidateRows[$RowNumber].getElementsByTagName('td')[$TitleColumnNumber].innerHTML -match 'goToDetails\("(.+)"\);') {
            # goToDetails contains update's GUID which we use then to request an update download page.
            $GUID = $matches[1]
        }
        else {
            Write-Error -Message ('Could not find a GUID for KB {0}' -f $KB)
            return
        }
    }

    if ($GUID -is [Guid]) {
        # Since the function parameter should be of the [guid] type, to simplify validation, and we actually need a string (and set $GUID to a string if the work mode is NOT "ByGUID"), it's easier to just check&convert the type on-the-fly.
        [string]$GUID = $Guid.Guid
    }

    Write-Verbose -Message ('Downloading GUID {0}' -f $GUID)
    if ($PSCmdlet.ParameterSetName -eq 'Default') {
        try {
            $DownloadLinks = GetKBDownloadLinksByGUID -DownloadPageTemplate $DownloadPageTemplate -GUID $GUID -KB $KB -ForceSSL:$ForceSSL
        }
        catch {
            $Params = NewCustomErrorRecord -Message ('Error invoking GetKBDownloadLinksByGUID for GUID {0} and KB {1}' -f $GUID, $KB) -ErrorRecord $_
            Write-Error @Params
            return
        }
    }
    else {
        try {
            $DownloadLinks = GetKBDownloadLinksByGUID -DownloadPageTemplate $DownloadPageTemplate -GUID $GUID -ForceSSL:$ForceSSL
        }
        catch {
            $Params = NewCustomErrorRecord -Message ('Error invoking GetKBDownloadLinksByGUID for GUID {0}' -f $GUID) -ErrorRecord $_
            Write-Error @Params
            return
        }
    }

    if ($DownloadLinks) {
        if ($LinksOnly) {
            $DownloadLinks
        }
        else {
            foreach ($URL in $DownloadLinks) {
                if ($URL -match '.+/(.+)$') {
                    Write-Verbose -Message ('Downloading file {0}' -f $URL)
                    if ($PSCmdlet.ParameterSetName -eq 'Default') {
                        try {
                            DownloadWUFile -URL $URL -DestinationFolder $DestinationFolder -FileName $Matches[1] -KB $KB
                        }
                        catch {
                            $Params = NewCustomErrorRecord -Message ('Error invoking DownloadWUFile for URL {0} and KB {1}' -f $URL, $KB) -ErrorRecord $_
                            Write-Error @Params
                            return
                        }
                    }
                    else {
                        try {
                            DownloadWUFile -URL $URL -DestinationFolder $DestinationFolder -FileName $Matches[1] -GUID $GUID
                        }
                        catch {
                            $Params = NewCustomErrorRecord -Message ('Error invoking DownloadWUFile for URL {0} and GUID {1}' -f $URL, $GUID) -ErrorRecord $_
                            Write-Error @Params
                            return
                        }
                    }
                }
                else {
                    if ($PSCmdlet.ParameterSetName -eq 'Default') {
                        Write-Error -Message ('URL {0} for KB {1} does not match the scheme' -f $URL, $KB)
                        return
                    }
                    else {
                        Write-Error -Message ('URL {0} for GUID {1} does not match the scheme' -f $URL, $GUID)
                        return
                    }
                }
            }
        }
    }
    else {
        if ($PSCmdlet.ParameterSetName -eq 'Default') {
            Write-Error -Message ('No download links for KB {0} have been generated' -f $KB)
            return
        }
        else {
            Write-Error -Message ('No download links for GUID {0} have been generated' -f $GUID)
            return
        }
    }
    #>
}
