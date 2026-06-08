<#
.SYNOPSIS
Exports a governed document inventory for declared SharePoint Online sites.

.DESCRIPTION
Reads SharePoint Online document libraries with PnP.PowerShell and exports
metadata for files only. When -ReadContent is explicitly provided, it also
downloads bounded copies to a temporary local folder, extracts readable text for
supported formats, and creates a short heuristic summary. The script does not
write to SharePoint, read versions, or read permissions.

Default target sites:
- https://escribaniabitsch.sharepoint.com/sites/SeshatHubRegistroN.8
- https://escribaniabitsch.sharepoint.com/sites/EscribaniaBitschRegistroNotarialN8

.EXAMPLE
pwsh ./scripts/sharepoint/Export-SharePointDocumentInventory.ps1 -AuthMode Interactive

.EXAMPLE
pwsh ./scripts/sharepoint/Export-SharePointDocumentInventory.ps1 `
  -AuthMode DeviceLogin `
  -ClientId "00000000-0000-0000-0000-000000000000" `
  -OutputDirectory "$env:TEMP/cabina-sharepoint-inventory"

.EXAMPLE
pwsh ./.agents/codex/tools/Export-SharePointDocumentInventory.ps1 `
  -AuthMode Interactive `
  -ReadContent `
  -MaxFileBytesForContent 5242880 `
  -MaxContentChars 4000
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [string[]] $SiteUrls = @(
        'https://escribaniabitsch.sharepoint.com/sites/SeshatHubRegistroN.8',
        'https://escribaniabitsch.sharepoint.com/sites/EscribaniaBitschRegistroNotarialN8'
    ),

    [ValidateSet('Interactive', 'DeviceLogin', 'OSLogin', 'ExistingConnection')]
    [string] $AuthMode = 'Interactive',

    [string] $ClientId,

    [string] $OutputDirectory = (Join-Path $env:TEMP 'cabina-sharepoint-inventory'),

    [switch] $IncludeSubsites,

    [switch] $IncludeHiddenLibraries,

    [switch] $IncludeUserEmails,

    [int] $PageSize = 500,

    [int] $SampleSize = 25,

    [switch] $ReadContent,

    [ValidateRange(256, 200000)]
    [int] $MaxContentChars = 4000,

    [ValidateRange(1, 10)]
    [int] $SummaryMaxLines = 5,

    [ValidateRange(1024, 104857600)]
    [int64] $MaxFileBytesForContent = 5242880,

    [string[]] $ReadableExtensions = @('aspx', 'csv', 'docx', 'htm', 'html', 'json', 'md', 'txt', 'xml'),

    [ValidateRange(0, 8)]
    [int] $RetryCount = 3,

    [ValidateRange(1, 120)]
    [int] $RetryDelaySeconds = 5
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Convert-ToSafeFileName {
    param([Parameter(Mandatory = $true)][string] $Value)

    return ($Value -replace '[^A-Za-z0-9._-]+', '_').Trim('_')
}

function Invoke-WithRetry {
    param(
        [Parameter(Mandatory = $true)][scriptblock] $ScriptBlock,
        [Parameter(Mandatory = $true)][string] $OperationName
    )

    $attempt = 0
    while ($true) {
        try {
            return & $ScriptBlock
        }
        catch {
            $attempt++
            $message = [string] $_.Exception.Message
            $isRetryable = $message -match '(429|throttl|too many requests|503|temporarily unavailable|timeout)'
            if (-not $isRetryable -or $attempt -gt $RetryCount) {
                throw "Failed $OperationName after $attempt attempt(s): $message"
            }

            $delay = [Math]::Min($RetryDelaySeconds * [Math]::Pow(2, ($attempt - 1)), 120)
            Write-Warning "$OperationName was throttled or temporarily unavailable. Retrying in $delay second(s)."
            Start-Sleep -Seconds $delay
        }
    }
}

function Get-FileExtension {
    param(
        [string] $LeafName,
        [string] $SharePointExtension
    )

    if (-not [string]::IsNullOrWhiteSpace($SharePointExtension)) {
        return $SharePointExtension.TrimStart('.').ToLowerInvariant()
    }

    $extension = [System.IO.Path]::GetExtension($LeafName)
    if ([string]::IsNullOrWhiteSpace($extension)) {
        return ''
    }

    return $extension.TrimStart('.').ToLowerInvariant()
}

function Get-MimeType {
    param([string] $Extension)

    $normalized = ([string] $Extension).TrimStart('.').ToLowerInvariant()
    $mimeTypes = @{
        aspx = 'text/html'
        csv  = 'text/csv'
        docx = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
        gif  = 'image/gif'
        htm  = 'text/html'
        html = 'text/html'
        jpeg = 'image/jpeg'
        jpg  = 'image/jpeg'
        json = 'application/json'
        md   = 'text/markdown'
        pdf  = 'application/pdf'
        png  = 'image/png'
        pptx = 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
        txt  = 'text/plain'
        xls  = 'application/vnd.ms-excel'
        xlsx = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
        xml  = 'application/xml'
        zip  = 'application/zip'
    }

    if ($mimeTypes.ContainsKey($normalized)) {
        return $mimeTypes[$normalized]
    }

    if ([string]::IsNullOrWhiteSpace($normalized)) {
        return 'application/octet-stream'
    }

    return 'application/octet-stream'
}

function ConvertFrom-MarkupText {
    param([string] $Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return ''
    }

    $withoutScripts = $Text -replace '(?is)<(script|style)[^>]*>.*?</\1>', ' '
    $withoutTags = $withoutScripts -replace '(?s)<[^>]+>', ' '
    return [System.Net.WebUtility]::HtmlDecode($withoutTags)
}

function Get-DocxText {
    param([Parameter(Mandatory = $true)][string] $Path)

    Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
    $archive = [System.IO.Compression.ZipFile]::OpenRead($Path)
    try {
        $entry = $archive.GetEntry('word/document.xml')
        if ($null -eq $entry) {
            return ''
        }

        $stream = $entry.Open()
        try {
            $reader = New-Object System.IO.StreamReader($stream, [System.Text.Encoding]::UTF8)
            try {
                $xmlText = $reader.ReadToEnd()
            }
            finally {
                $reader.Dispose()
            }
        }
        finally {
            $stream.Dispose()
        }

        return ConvertFrom-MarkupText -Text $xmlText
    }
    finally {
        $archive.Dispose()
    }
}

function Normalize-ExtractedText {
    param([string] $Text)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return ''
    }

    return (($Text -replace '\r', ' ') -replace '\n', ' ' -replace '\s+', ' ').Trim()
}

function New-HeuristicSummary {
    param(
        [string] $Text,
        [int] $MaxLines
    )

    $normalized = Normalize-ExtractedText -Text $Text
    if ([string]::IsNullOrWhiteSpace($normalized)) {
        return ''
    }

    $sentences = [regex]::Split($normalized, '(?<=[\.\!\?])\s+') |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Select-Object -First $MaxLines

    if (($sentences | Measure-Object).Count -eq 0) {
        $sentences = @($normalized.Substring(0, [Math]::Min($normalized.Length, 700)))
    }

    return (($sentences | ForEach-Object { $_.Trim() }) -join [Environment]::NewLine)
}

function Read-InventoryFileContent {
    param(
        [Parameter(Mandatory = $true)][string] $FileRef,
        [Parameter(Mandatory = $true)][string] $LeafName,
        [Parameter(Mandatory = $true)][string] $Extension,
        [Parameter(Mandatory = $true)][int64] $SizeBytes,
        [Parameter(Mandatory = $true)][string] $TempDirectory
    )

    if (-not $ReadContent) {
        return [pscustomobject]@{
            status  = 'not_requested'
            text    = ''
            summary = ''
            error   = ''
        }
    }

    $normalizedExtension = ([string] $Extension).TrimStart('.').ToLowerInvariant()
    if ($ReadableExtensions -notcontains $normalizedExtension) {
        return [pscustomobject]@{
            status  = 'unsupported_type'
            text    = ''
            summary = ''
            error   = ''
        }
    }

    if ($SizeBytes -gt $MaxFileBytesForContent) {
        return [pscustomobject]@{
            status  = 'skipped_size_limit'
            text    = ''
            summary = ''
            error   = "File size $SizeBytes exceeds MaxFileBytesForContent $MaxFileBytesForContent."
        }
    }

    $safeName = "$(Convert-ToSafeFileName -Value ([guid]::NewGuid().ToString()))_$(Convert-ToSafeFileName -Value $LeafName)"
    $downloadPath = Join-Path $TempDirectory $safeName

    try {
        Invoke-WithRetry -OperationName "download $FileRef" -ScriptBlock {
            Get-PnPFile -Url $FileRef -Path $TempDirectory -FileName $safeName -AsFile -Force -ErrorAction Stop | Out-Null
        } | Out-Null

        switch ($normalizedExtension) {
            'docx' {
                $rawText = Get-DocxText -Path $downloadPath
            }
            { $_ -in @('aspx', 'htm', 'html', 'xml') } {
                $rawText = ConvertFrom-MarkupText -Text (Get-Content -Path $downloadPath -Raw -Encoding UTF8)
            }
            default {
                $rawText = Get-Content -Path $downloadPath -Raw -Encoding UTF8
            }
        }

        $normalizedText = Normalize-ExtractedText -Text $rawText
        if ($normalizedText.Length -gt $MaxContentChars) {
            $normalizedText = $normalizedText.Substring(0, $MaxContentChars)
        }

        $summary = New-HeuristicSummary -Text $normalizedText -MaxLines $SummaryMaxLines
        $status = if ([string]::IsNullOrWhiteSpace($normalizedText)) { 'empty' } else { 'read' }

        return [pscustomobject]@{
            status  = $status
            text    = $normalizedText
            summary = $summary
            error   = ''
        }
    }
    catch {
        return [pscustomobject]@{
            status  = 'error'
            text    = ''
            summary = ''
            error   = [string] $_.Exception.Message
        }
    }
    finally {
        if (Test-Path -LiteralPath $downloadPath) {
            Remove-Item -LiteralPath $downloadPath -Force
        }
    }
}

function Connect-InventorySharePoint {
    param([Parameter(Mandatory = $true)][string] $Url)

    if ($AuthMode -eq 'ExistingConnection') {
        $connection = Get-PnPConnection -ErrorAction SilentlyContinue
        if ($null -eq $connection) {
            throw 'AuthMode ExistingConnection was requested, but no PnP connection is active.'
        }
        if ($connection.Url -ne $Url) {
            throw "Active PnP connection URL '$($connection.Url)' does not match target '$Url'."
        }
        return
    }

    $params = @{
        Url         = $Url
        ErrorAction = 'Stop'
    }
    if ($ClientId) {
        $params.ClientId = $ClientId
    }

    switch ($AuthMode) {
        'Interactive' { $params.Interactive = $true }
        'DeviceLogin' { $params.DeviceLogin = $true }
        'OSLogin' { $params.OSLogin = $true }
    }

    Connect-PnPOnline @params
}

function Get-UserDisplay {
    param([object] $Value)

    if ($null -eq $Value) {
        return ''
    }

    if ($Value -is [array]) {
        return (($Value | ForEach-Object { Get-UserDisplay -Value $_ }) -join '; ')
    }

    $display = $null
    foreach ($propertyName in @('LookupValue', 'Email', 'Name')) {
        $property = $Value.PSObject.Properties[$propertyName]
        if ($property -and -not [string]::IsNullOrWhiteSpace([string] $property.Value)) {
            $display = [string] $property.Value
            break
        }
    }

    if ($null -eq $display) {
        $display = [string] $Value
    }

    if (-not $IncludeUserEmails) {
        $display = $display -replace '\S+@\S+', '[email-redacted]'
    }

    return $display
}

function Get-FieldValue {
    param(
        [Parameter(Mandatory = $true)][hashtable] $Values,
        [Parameter(Mandatory = $true)][string] $Name
    )

    if ($Values.ContainsKey($Name)) {
        return $Values[$Name]
    }
    return $null
}

function Get-SiteInventory {
    param(
        [Parameter(Mandatory = $true)][string] $SiteUrl,
        [Parameter(Mandatory = $true)][string] $TempDirectory
    )

    Connect-InventorySharePoint -Url $SiteUrl

    $web = Get-PnPWeb -Includes Url,Title,ServerRelativeUrl
    $siteTargets = @(
        [pscustomobject]@{
            Url                = $web.Url
            Title              = $web.Title
            ServerRelativeUrl  = $web.ServerRelativeUrl
            IsSubsite          = $false
        }
    )

    if ($IncludeSubsites) {
        $subsites = Get-PnPSubWeb -Recurse -Includes Url,Title,ServerRelativeUrl
        foreach ($subsite in $subsites) {
            $siteTargets += [pscustomobject]@{
                Url               = $subsite.Url
                Title             = $subsite.Title
                ServerRelativeUrl = $subsite.ServerRelativeUrl
                IsSubsite         = $true
            }
        }
    }

    $rows = New-Object System.Collections.Generic.List[object]
    $libraryRows = New-Object System.Collections.Generic.List[object]

    foreach ($siteTarget in $siteTargets) {
        if ($siteTarget.Url -ne $web.Url) {
            Connect-InventorySharePoint -Url $siteTarget.Url
        }

        $currentWeb = Get-PnPWeb -Includes Url,Title,ServerRelativeUrl
        $lists = Get-PnPList -Includes Id,Title,RootFolder,BaseTemplate,BaseType,Hidden,ItemCount
        $documentLibraries = $lists | Where-Object {
            $_.BaseType -eq 'DocumentLibrary' -and
            $_.BaseTemplate -in @(101, 119) -and
            ($IncludeHiddenLibraries -or -not $_.Hidden)
        } | Sort-Object Title

        foreach ($library in $documentLibraries) {
            $libraryFileCount = 0
            $rootFolderUrl = $library.RootFolder.ServerRelativeUrl
            $query = @"
<View Scope='RecursiveAll'>
  <Query>
    <Where>
      <Eq>
        <FieldRef Name='FSObjType' />
        <Value Type='Integer'>0</Value>
      </Eq>
    </Where>
  </Query>
</View>
"@

            $items = Get-PnPListItem `
                -List $library.Id `
                -PageSize $PageSize `
                -Fields 'FileLeafRef', 'FileRef', 'File_x0020_Size', 'SMTotalFileStreamSize', 'File_x0020_Type', 'Created', 'Modified', 'Author', 'Editor', 'ContentType', 'UniqueId' `
                -Query $query

            foreach ($item in $items) {
                $values = $item.FieldValues
                $fileRef = [string] (Get-FieldValue -Values $values -Name 'FileRef')
                if ([string]::IsNullOrWhiteSpace($fileRef)) {
                    continue
                }
                if ($fileRef -like "$rootFolderUrl/Forms/*") {
                    continue
                }

                $libraryFileCount++
                $siteRelativePath = $fileRef
                if ($fileRef.StartsWith($currentWeb.ServerRelativeUrl, [System.StringComparison]::OrdinalIgnoreCase)) {
                    $siteRelativePath = $fileRef.Substring($currentWeb.ServerRelativeUrl.Length)
                }
                if (-not $siteRelativePath.StartsWith('/')) {
                    $siteRelativePath = '/' + $siteRelativePath
                }

                $leafName = [string] (Get-FieldValue -Values $values -Name 'FileLeafRef')
                $extension = Get-FileExtension `
                    -LeafName $leafName `
                    -SharePointExtension ([string] (Get-FieldValue -Values $values -Name 'File_x0020_Type'))
                $size = Get-FieldValue -Values $values -Name 'File_x0020_Size'
                if ($null -eq $size) {
                    $size = Get-FieldValue -Values $values -Name 'SMTotalFileStreamSize'
                }
                $sizeBytes = [int64] ($size ?? 0)

                $contentRead = Read-InventoryFileContent `
                    -FileRef $fileRef `
                    -LeafName $leafName `
                    -Extension $extension `
                    -SizeBytes $sizeBytes `
                    -TempDirectory $TempDirectory

                $rows.Add([pscustomobject]@{
                    site_title         = $currentWeb.Title
                    site_url           = $currentWeb.Url
                    site_is_subsite    = [bool] $siteTarget.IsSubsite
                    library_title      = $library.Title
                    library_url        = $rootFolderUrl
                    file_name          = $leafName
                    file_path          = $fileRef
                    file_url           = ($currentWeb.Url.TrimEnd('/') + $siteRelativePath)
                    file_extension     = $extension
                    mime_type          = Get-MimeType -Extension $extension
                    content_type       = [string] (Get-FieldValue -Values $values -Name 'ContentType')
                    size_bytes         = $sizeBytes
                    created_utc        = Get-FieldValue -Values $values -Name 'Created'
                    modified_utc       = Get-FieldValue -Values $values -Name 'Modified'
                    created_by         = Get-UserDisplay -Value (Get-FieldValue -Values $values -Name 'Author')
                    modified_by        = Get-UserDisplay -Value (Get-FieldValue -Values $values -Name 'Editor')
                    unique_id          = [string] (Get-FieldValue -Values $values -Name 'UniqueId')
                    content_read_status = $contentRead.status
                    content_chars      = $contentRead.text.Length
                    content_text       = $contentRead.text
                    summary            = $contentRead.summary
                    summary_method     = if ($ReadContent) { 'local_heuristic_extractive' } else { 'not_requested' }
                    read_error         = $contentRead.error
                    source             = if ($ReadContent) { 'PnP.PowerShell metadata+bounded-content' } else { 'PnP.PowerShell metadata-only' }
                })
            }

            $libraryRows.Add([pscustomobject]@{
                site_title              = $currentWeb.Title
                site_url                = $currentWeb.Url
                site_is_subsite         = [bool] $siteTarget.IsSubsite
                library_title           = $library.Title
                library_url             = $rootFolderUrl
                sharepoint_item_count   = $library.ItemCount
                exported_document_count = $libraryFileCount
                hidden                  = [bool] $library.Hidden
                base_template           = $library.BaseTemplate
            })
        }
    }

    return [pscustomobject]@{
        Documents = $rows
        Libraries = $libraryRows
    }
}

if (-not (Get-Module -ListAvailable -Name PnP.PowerShell)) {
    throw 'PnP.PowerShell is required. Install or make the module available before running this script.'
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$contentTempDirectory = Join-Path $OutputDirectory "content_temp_$timestamp"
if ($ReadContent) {
    New-Item -ItemType Directory -Path $contentTempDirectory -Force | Out-Null
}
$allDocuments = New-Object System.Collections.Generic.List[object]
$allLibraries = New-Object System.Collections.Generic.List[object]

foreach ($siteUrl in $SiteUrls) {
    $operation = if ($ReadContent) {
        'Export SharePoint document inventory metadata and bounded readable content'
    }
    else {
        'Export SharePoint document inventory metadata'
    }

    if ($PSCmdlet.ShouldProcess($siteUrl, $operation)) {
        $inventory = Get-SiteInventory -SiteUrl $siteUrl -TempDirectory $contentTempDirectory
        foreach ($document in $inventory.Documents) {
            $allDocuments.Add($document)
        }
        foreach ($library in $inventory.Libraries) {
            $allLibraries.Add($library)
        }
    }
}

$inventoryPath = Join-Path $OutputDirectory "sharepoint_document_inventory_$timestamp.csv"
$inventoryJsonPath = Join-Path $OutputDirectory "sharepoint_document_inventory_$timestamp.json"
$librariesPath = Join-Path $OutputDirectory "sharepoint_library_summary_$timestamp.csv"
$samplePath = Join-Path $OutputDirectory "sharepoint_inventory_validation_sample_$timestamp.csv"
$summaryPath = Join-Path $OutputDirectory "sharepoint_inventory_summary_$timestamp.json"

$sortedDocuments = @($allDocuments | Sort-Object site_url, library_title, file_path)
$sortedLibraries = @($allLibraries | Sort-Object site_url, library_title)

$sortedDocuments |
    Export-Csv -Path $inventoryPath -NoTypeInformation -Encoding UTF8

$inventoryJson = if ($sortedDocuments.Count -eq 0) {
    '[]'
}
else {
    $sortedDocuments | ConvertTo-Json -Depth 8
}
$inventoryJson | Set-Content -Path $inventoryJsonPath -Encoding UTF8

$sortedLibraries |
    Export-Csv -Path $librariesPath -NoTypeInformation -Encoding UTF8

$sortedDocuments |
    Select-Object -First $SampleSize |
    Export-Csv -Path $samplePath -NoTypeInformation -Encoding UTF8

$contentStatusCounts = @($allDocuments |
    Group-Object content_read_status |
    Sort-Object Name |
    ForEach-Object {
        [pscustomobject]@{
            status = $_.Name
            count  = $_.Count
        }
    })

$siteSummaries = @($allLibraries |
    Group-Object site_url |
    ForEach-Object {
        $siteUrl = $_.Name
        [pscustomobject]@{
            site_url       = $siteUrl
            library_count  = ($_.Group | Measure-Object).Count
            document_count = ($allDocuments | Where-Object { $_.site_url -eq $siteUrl } | Measure-Object).Count
        }
    })

$summary = [pscustomobject]@{
    status                 = if ($ReadContent) { 'EXPORTED_METADATA_AND_BOUNDED_CONTENT' } else { 'EXPORTED_METADATA_ONLY' }
    generated_at_utc       = (Get-Date).ToUniversalTime().ToString('o')
    site_count             = ($SiteUrls | Select-Object -Unique).Count
    library_count          = $allLibraries.Count
    document_count         = $allDocuments.Count
    include_subsites       = [bool] $IncludeSubsites
    include_hidden_libraries = [bool] $IncludeHiddenLibraries
    include_user_emails    = [bool] $IncludeUserEmails
    read_content           = [bool] $ReadContent
    max_content_chars      = if ($ReadContent) { $MaxContentChars } else { 0 }
    max_file_bytes_for_content = if ($ReadContent) { $MaxFileBytesForContent } else { 0 }
    readable_extensions    = if ($ReadContent) { $ReadableExtensions } else { @() }
    content_read_status_counts = $contentStatusCounts
    output_files           = [pscustomobject]@{
        inventory_csv  = $inventoryPath
        inventory_json = $inventoryJsonPath
        libraries_csv  = $librariesPath
        sample_csv     = $samplePath
        summary_json   = $summaryPath
    }
    sites                  = $siteSummaries
}

$summary | ConvertTo-Json -Depth 6 | Set-Content -Path $summaryPath -Encoding UTF8
$summary | ConvertTo-Json -Depth 6

if ($ReadContent -and (Test-Path -LiteralPath $contentTempDirectory)) {
    Remove-Item -LiteralPath $contentTempDirectory -Force -Recurse
}
