$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (! (Get-Module Powershell-Yaml -ListAvailable) ) {
    Install-Module Powershell-Yaml -Scope CurrentUser -Force
}
Import-Module Powershell-Yaml

$VERSIONS = Get-Content $PSScriptRoot/versions.json -Encoding utf8 | ConvertFrom-Json -Depth 100

$y = (Invoke-WebRequest https://raw.githubusercontent.com/kubernetes/website/main/data/releases/eol.yaml).Content | ConvertFrom-Yaml
$VERSIONS_EOL = @( $y.branches | % { $_.finalPatchRelease } )
$y = (Invoke-WebRequest https://raw.githubusercontent.com/kubernetes/website/main/data/releases/schedule.yaml).Content | ConvertFrom-Yaml
$VERSIONS_NEW = @( $y.schedules | % { $_.previousPatches[0].release } )

function Update-Versions ($VERSIONS, $VERSIONS_NEW) {
    for ($i = 0; $i -lt $VERSIONS.Length; $i++) {
        $v = [version]$VERSIONS[$i]
        foreach ($vn in $VERSIONS_NEW) {
            $vn = [version]$vn
            if ($v.Major -eq $vn.Major -and $v.Minor -eq $vn.Minor -and $v.Build -lt $vn.Build) {
                "Updating $v to $vn" | Write-Host -ForegroundColor Green
                $VERSIONS[$i] = $vn.ToString()
                $VERSIONS | ConvertTo-Json -Depth 100 | Set-Content $PSScriptRoot/versions.json -Encoding utf8
                git checkout -f master
                Generate-DockerImageVariants .
                $BRANCH = "enhancement/bump-v$( $v.Major ).$( $v.Minor )-variants-to-$( $vn )"
                $COMMIT_MSG = "Enhancement: Bump v$( $v.Major ).$( $v.Minor ) variants to $( $vn )"
                git checkout -b $BRANCH
                git add .
                git commit -m $COMMIT_MSG
                git push origin $BRANCH
                gh pr create -B master -H $BRANCH --title $COMMIT_MSG
            }
        }
    }
}

Update-Versions $VERSIONS $VERSIONS_EOL
Update-Versions $VERSIONS $VERSIONS_NEW
