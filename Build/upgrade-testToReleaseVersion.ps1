# Upgrade-to-release.ps1: Replace Test Tag with Release Tag (Optionally Publish to PowerShell Gallery)

<#
.DESCRIPTION
This script upgrades a Git test release (tagged with a suffix like `-test`) to a final release by:
1. Verifying that the test tag exists on the current commit.
2. Replacing the test tag (e.g., `vX.X.X-test`) with a final release tag (e.g., `vX.X.X`).
3. Optionally, running the `publish-toPsGallery.ps1` script to push the module to the PowerShell Gallery by using the `-p` or `-Publish` parameter.

.PARAMETER Publish
Use this parameter to enable publishing to the PowerShell Gallery via the `publish-toPsGallery.ps1` script.

.REQUIREMENTS
- Git must be installed and accessible from the command line.
- A `publish-toPsGallery.ps1` script must exist for publishing if the `-p` parameter is used.
- The test tag (`vX.X.X-test`) must be present on the current commit.

#>

param (
    [Switch]$Publish # Optional switch to trigger publishing
)

# Define the path to the `publish-toPsGallery.ps1` script
$publishScriptPath = Join-Path $PSScriptRoot "./publish-toPsGallery.ps1"

# Step 1: Ensure the repository state is clean
Write-Host "Step 1: Verifying repository state..."
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Error "Your repository has uncommitted changes. Please commit or stash your changes before proceeding."
    exit 1
}

Write-Host "Repository is clean. Proceeding..."

# Step 2: Verify a test tag is present on the current commit
Write-Host "Step 2: Checking for a test tag on the current commit..."
$currentCommitHash = git rev-parse HEAD
$testTagsOnCommit = git tag --points-at $currentCommitHash | Where-Object { $_ -match "-test$" }

if (-Not $testTagsOnCommit) {
    Write-Error "No test tag is present on the current commit ($currentCommitHash). Ensure the current commit has an associated test tag."
    exit 1
}

$testTag = $testTagsOnCommit | Select-Object -First 1
Write-Host "Found test tag on the current commit: $testTag"

$releaseTag = $testTag -replace "-test$", ""
Write-Host "Release tag will be: $releaseTag"

# Step 3: Replace the test tag with the release tag
Write-Host "Step 3: Replacing the test tag with a release tag..."
git tag -d $testTag
git tag $releaseTag
git push origin :refs/tags/$testTag
git push origin $releaseTag
Write-Host "Test tag '$testTag' replaced with release tag '$releaseTag' and pushed to the repository."

# Step 4: Optionally Publish to PowerShell Gallery
if ($Publish) {
    Write-Host "Step 4: Running publish-toPsGallery.ps1..."
    if (-Not (Test-Path $publishScriptPath)) {
        Write-Error "The script 'publish-toPsGallery.ps1' was not found. Publishing cannot proceed."
        exit 1
    }
    & $publishScriptPath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Publishing to PowerShell Gallery failed. Please check the output for errors."
        exit 1
    }
    Write-Host "Module successfully published to PowerShell Gallery under release tag '$releaseTag'."
} else {
    Write-Host "Publishing step skipped as the -p (or -Publish) parameter was not provided."
}
Write-Host "Upgrade process complete."
exit 0
