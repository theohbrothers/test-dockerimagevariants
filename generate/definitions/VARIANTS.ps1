$local:VERSIONS = Get-Content $PSScriptRoot/versions.json -Encoding utf8 | ConvertFrom-Json -Depth 100

# Docker image variants' definitions
$local:VARIANTS_MATRIX = @(
    foreach ($v in $local:VERSIONS.coolpackage.versions) {
        @{
            package_version = "v$v"
            distro = 'alpine'
            distro_version = '3.15'
            subvariants = @(
                @{ components = @(); tag_as_latest = if ($v -eq ($local:VERSIONS.coolpackage.versions | ? { $_ -match '^\d+\.\d+\.\d+$' } | Select-Object -First 1 )) { $true } else { $false } }
                @{ components = @( 'curl' ) }
                @{ components = @( 'curl', 'git' ) }
            )
        }
    }
)
$VARIANTS = @(
    foreach ($variant in $VARIANTS_MATRIX){
        foreach ($subVariant in $variant['subvariants']) {
            @{
                # Metadata object
                _metadata = @{
                    package_version = $variant['package_version']
                    distro = $variant['distro']
                    distro_version = $variant['distro_version']
                    platforms =  'linux/386,linux/amd64,linux/arm/v6,linux/arm/v7,linux/arm64,linux/s390x'
                    components = $subVariant['components']
                }
                # Docker image tag. E.g. 'v2.3.0.0-alpine-3.6'
                tag = @(
                        $variant['package_version']
                        $subVariant['components'] | ? { $_ }
                        $variant['distro']
                        $variant['distro_version']
                ) -join '-'
                tag_as_latest = if ( $subVariant.Contains('tag_as_latest') ) {
                                    $subVariant['tag_as_latest']
                                } else {
                                    $false
                                }
            }
        }
    }
)

# Docker image variants' definitions (shared)
$VARIANTS_SHARED = @{
    buildContextFiles = @{
        templates = @{
            'Dockerfile' = @{
                common = $true
                passes = @(
                    @{
                        variables = @{}
                    }
                )
            }
        }
    }
}
