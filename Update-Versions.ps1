# This script is to update versions in version.json, and create PR(s) for each bumped version
# It may be run manually or as a cron
[CmdletBinding()]
param (
    [Parameter(HelpMessage="Whether to perform a dry run (skip writing versions.json)")]
    [switch]$DryRun
,
    [Parameter(HelpMessage="Whether to open a PR for each updated version in version.json")]
    [switch]$PR
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Install modules
@(
    'Generate-DockerImageVariantsHelpers'
    'Powershell-Yaml'
) | % {
    if (! (Get-InstalledModule $_) ) {
        Install-Module $_ -Scope CurrentUser -Force
    }
}

if (Test-Path ../Generate-DockerImageVariantsHelpers/src/Generate-DockerImageVariantsHelpers) {
    Import-module ../Generate-DockerImageVariantsHelpers/src/Generate-DockerImageVariantsHelpers -Force
}

Clone-TempRepo

$versionsNew = @(
    '0.4.0'
    '0.3.1'
    '0.2.1'
    '0.1.0'
)
$versionsChanged = Get-VersionsChanged -Versions (Get-DockerImageVariantsVersions) -VersionsNew $versionsNew -AsObject -Descending
Update-DockerImageVariantsVersions -VersionsChanged $versionsChanged -PR:$PR
