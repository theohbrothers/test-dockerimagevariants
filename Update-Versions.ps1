# This script is to update versions in version.json, and create PR(s) for each bumped version
# It may be run manually or as a cron
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(HelpMessage="Whether to clone a temporary repo before opening PRs. Useful in development")]
    [switch]$CloneTempRepo
,
    [Parameter(HelpMessage="Whether to open a PR for each updated version in version.json")]
    [switch]$PR
,
    [Parameter(HelpMessage="Whether to merge each PR one after another (note that this is not GitHub merge queue which cannot handle merge conflicts). The queue ensures each PR is rebased to prevent merge conflicts")]
    [switch]$AutoMergeQueue
,
    [Parameter(HelpMessage="Whether to create a tagged release and closing milestone, after merging all PRs")]
    [switch]$AutoRelease
,
    [Parameter(HelpMessage="-AutoRelease tag convention")]
    [ValidateSet('calver', 'semver')]
    [string]$AutoReleaseTagConvention = 'calver'
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

# Install modules
@(
    'Generate-DockerImageVariantsHelpers'
    'Powershell-Yaml'
) | % {
    if (! (Get-InstalledModule $_ -ErrorAction SilentlyContinue) ) {
        Install-Module $_ -Scope CurrentUser -Force
    }
}

# Override with development module if it exists
if (Test-Path ../Generate-DockerImageVariantsHelpers/src/Generate-DockerImageVariantsHelpers) {
    Import-module ../Generate-DockerImageVariantsHelpers/src/Generate-DockerImageVariantsHelpers -Force
}

try {
    if ($CloneTempRepo) {
        $repo = Clone-TempRepo
        Push-Location $repo
    }

    $versionsNew = @(
        "0.4.4"
        "0.3.6"
        "0.2.10"
        "0.1.0"
    )
    $versionsChanged = Get-VersionsChanged -Versions (Get-DockerImageVariantsVersions) -VersionsNew $versionsNew -AsObject -Descending
    $autoMergeResults = Update-DockerImageVariantsVersions -VersionsChanged $versionsChanged -PR:$PR -AutoMergeQueue:$AutoMergeQueue -AutoRelease:$AutoRelease -AutoReleaseTagConvention $AutoReleaseTagConvention -WhatIf:$WhatIfPreference
}catch {
    throw
}finally {
    if ($CloneTempRepo) {
        Pop-Location
    }
}
