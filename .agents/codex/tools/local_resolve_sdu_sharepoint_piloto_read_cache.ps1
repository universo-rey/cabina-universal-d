param(
  [string]$RepoRoot = ".",
  [string]$CachePath = ".agents/codex/evals/results/sdu_sharepoint_piloto_live_read_latest.json",
  [string]$SiteUrl = "https://escribaniabitsch.sharepoint.com/sites/SYS-GobiernoOperativo-PILOTO",
  [string]$ListName = ""
)

$ErrorActionPreference = "Stop"

function Join-RepoPath {
  param([string]$Path)
  if ([System.IO.Path]::IsPathRooted($Path)) {
    return $Path
  }
  return Join-Path $RepoRoot $Path
}

function Read-JsonFile {
  param([string]$Path)
  $resolved = Join-RepoPath -Path $Path
  if (-not (Test-Path -LiteralPath $resolved)) {
    return $null
  }
  return Get-Content -Raw -LiteralPath $resolved | ConvertFrom-Json
}

$cache = Read-JsonFile -Path $CachePath
$errors = New-Object System.Collections.Generic.List[string]

if ($null -eq $cache) {
  $errors.Add("missing_sharepoint_read_cache")
}

$siteMatches = $false
$requestedList = $null
$requestedLibrary = $null

if ($null -ne $cache) {
  $siteMatches = ($cache.site.url -eq $SiteUrl)

  if (-not [string]::IsNullOrWhiteSpace($ListName)) {
    $requestedList = @($cache.lists | Where-Object { $_.title -eq $ListName }) | Select-Object -First 1
    $requestedLibrary = @($cache.libraries | Where-Object { $_.name -eq $ListName }) | Select-Object -First 1
    if ($null -eq $requestedList -and $null -eq $requestedLibrary) {
      $errors.Add("requested_list_or_library_not_in_cache")
    }
  }
}

if ($null -ne $cache -and -not $siteMatches) {
  $errors.Add("site_url_mismatch")
}

$decision = "SHAREPOINT_READ_CACHE_READY"
if ($errors.Count -gt 0) {
  $decision = "SHAREPOINT_READ_CACHE_INCOMPLETE"
}

[pscustomobject]@{
  status = if ($errors.Count -eq 0 -and $siteMatches) { "PASS" } else { "FAIL" }
  decision = $decision
  cache_path = $CachePath
  generated_at = if ($null -ne $cache) { $cache.generated_at } else { $null }
  site = if ($null -ne $cache) { $cache.site } else { $null }
  summary = if ($null -ne $cache) {
    [pscustomobject]@{
      library_count = @($cache.libraries).Count
      list_count = @($cache.lists).Count
      sampled_list_count = @($cache.samples.PSObject.Properties.Name).Count
      connector_rest_list_items_supported = $cache.connector.native_list_rest_items_supported
      pnp_read_supported = $cache.pnp.read_supported
    }
  } else { $null }
  requested = [pscustomobject]@{
    name = $ListName
    list = $requestedList
    library = $requestedLibrary
  }
  no_repeat = [pscustomobject]@{
    live_refresh_required = $false
    connector_site_discovery_required = $false
    pnp_inventory_required = $false
    global_validation_required = $false
  }
  errors = $errors
} | ConvertTo-Json -Depth 10

if ($errors.Count -gt 0 -or -not $siteMatches) {
  exit 1
}
