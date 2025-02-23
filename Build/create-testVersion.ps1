# Combined Script: Increment Version, Run Manifest Generation, and Commit Changes

<#
.DESCRIPTION
This script performs the following:
1. Edits the `ModuleVersion` in `create-manifest.ps1` to increment the version.
2. Executes `create-manifest.ps1` to generate/update the module's `.psd1` manifest file.
3. Commits both the updated `create-manifest.ps1` and the resulting `.psd1` file to Git with an appropriate message.
4. Optionally tags the release in Git.

.STEPS
- Step 1: Locate and increment the version in `create-manifest.ps1`.
- Step 2: Execute the updated `create-manifest.ps1` to regenerate the `.psd1` manifest.
- Step 3: Commit the updated scripts and generated manifest to Git.

#>

# Define paths to relevant files
$createManifestScript  = Join-Path $PSScriptRoot "./create-manifest.ps1"
$generatedManifestPath = Join-Path $PSScriptRoot "../PSCmdManager/PSCmdManager.psd1"

if (-Not (Test-Path $createManifestScript)) {
    Write-Error "The script 'create-manifest.ps1' is not found. Aborting..."
    exit 1
}

# Step 1: Increment the version in `create-manifest.ps1`
Write-Host "Step 1: Incrementing the version in create-manifest.ps1..."
$fileContents = Get-Content -Path $createManifestScript -Raw
$moduleVersionRegex = "ModuleVersion\s*=\s*'(?<version>\d+\.\d+\.\d+)'"
if (-not ($fileContents -match $moduleVersionRegex)) {
    Write-Error "Failed to locate 'ModuleVersion' in create-manifest.ps1. Aborting..."
    exit 1
}
$currentVersion = [version]$Matches['version']
Write-Host "Current ModuleVersion: $currentVersion"

$incrementType = Read-Host "Which part of the version would you like to increment? (M - major, m - minor, p - patch)"
switch ($incrementType.ToLower()) {
    "M" { $newVersion = [version]"$($currentVersion.Major + 1).0.0" }
    "m" { $newVersion = [version]"$($currentVersion.Major).$($currentVersion.Minor + 1).0" }
    "p" { $newVersion = [version]"$($currentVersion.Major).$($currentVersion.Minor).$($currentVersion.Build + 1)" }
    default {
        Write-Error "Invalid option. Please choose 'major', 'minor', or 'patch'."
        exit 1
    }
}
Write-Host "New ModuleVersion: $newVersion"

$updatedContents = $fileContents -replace $moduleVersionRegex, "ModuleVersion = '$newVersion'"
Set-Content -Path $createManifestScript -Value $updatedContents
Write-Host "Version updated successfully in create-manifest.ps1."


# Step 2: Execute `create-manifest.ps1` to generate/update the `.psd1` file
Write-Host "Step 2: Running create-manifest.ps1 to regenerate the manifest..."
if (Test-Path $generatedManifestPath) {
    Remove-Item $generatedManifestPath -Force
    Write-Host "Existing manifest file '$generatedManifestPath' removed."
}
& $createManifestScript | Tee-Object -Variable scriptLog

if (-Not (Test-Path $generatedManifestPath))
{
    Write-Error "Execution of 'create-manifest.ps1' failed. Please check for errors in the script output."
    Write-Host "`nScript Log Output:`n$scriptLog"
    exit 1
}
Write-Host "'create-manifest.ps1' executed successfully. Manifest has been regenerated."


# Step 3: Commit the updated `create-manifest.ps1` and `.psd1` manifest to Git
Write-Host "Step 3: Committing changes to Git..."
git add $createManifestScript $generatedManifestPath
$commitMessage = "Bump module version to $newVersion and regenerate manifest"
git commit -m $commitMessage
git tag "v$newVersion-test"
git push origin --tags
Write-Host "Changes committed successfully, and version $newVersion-test has been tagged in Git."
