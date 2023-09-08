# test-dockerimagevariants

[![github-actions](https://github.com/theohbrothers/test-dockerimagevariants/workflows/ci-master-pr/badge.svg)](https://github.com/theohbrothers/test-dockerimagevariants/actions)
[![github-release](https://img.shields.io/github/v/release/theohbrothers/test-dockerimagevariants?style=flat-square)](https://github.com/theohbrothers/test-dockerimagevariants/releases/)
[![docker-image-size](https://img.shields.io/docker/image-size/theohbrothers/test-dockerimagevariants/latest)](https://hub.docker.com/r/theohbrothers/test-dockerimagevariants)

## Tags

<!-- When using Markdown table, changed adjacent lines results in merge conflicts. Instead, use a HTML table to keep changed lines apart to prevent merge conflicts. -->
<table>
<tr><th align="center">Tag</th><th align="center">Dockerfile Build Context</th></tr>

<tr><td align="center"><code>:v0.3.1-alpine-3.15</code>, <code>:latest</code></td><td align="center"><a href="variants/v0.3.1-alpine-3.15">View</a></td></tr>

<tr><td align="center"><code>:v0.2.5-alpine-3.15</code></td><td align="center"><a href="variants/v0.2.5-alpine-3.15">View</a></td></tr>

<tr><td align="center"><code>:v0.1.0-alpine-3.15</code></td><td align="center"><a href="variants/v0.1.0-alpine-3.15">View</a></td></tr>
</table>

## Development

Requires Windows `powershell` or [`pwsh`](https://github.com/PowerShell/PowerShell).

```powershell
# Install Generate-DockerImageVariants module: https://github.com/theohbrothers/Generate-DockerImageVariants
Install-Module -Name Generate-DockerImageVariants -Repository PSGallery -Scope CurrentUser -Force -Verbose

# Edit ./generate templates

# Generate the variants
Generate-DockerImageVariants .
```

### Variant versions

[versions.json](generate/definitions/versions.json) contains a list of [Semver](https://semver.org/) versions, one per line.

To list available version updates in `versions.json`:

```powershell
./Update-Versions.ps1 -DryRun
```

To update versions in `versions.json`:

```powershell
./Update-Versions.ps1
```

To update versions in `versions.json`, and open a PR for each updated version:

```powershell
./Update-Versions.ps1 -PR
```
