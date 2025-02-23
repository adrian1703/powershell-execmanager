param (
    [switch]$rm
,
    [switch]$getTargetPath
,
    [switch]$getModuleName
)

# Split the PSModulePath into individual paths
[string[]]$paths = "$env:PSModulePath" -split ";"
[string]$moduleInstallPath = $null

# Locate the user-specific module path
foreach ($path in $paths) {
    if ($path -like "*Users*") {
        $moduleInstallPath = $path
        break
    }
}

if (-not $moduleInstallPath) {
    Write-Error "User-specific module installation path not found. Unable to proceed."
    exit 1
}

# Define module details
$projectName = "PSCmdManager"
$targetPath  = Join-Path $moduleInstallPath $projectName
$sourcePath  = Join-Path (Join-Path $PSScriptRoot  "../") $projectName


if ($getTargetPath) {
    return $targetPath
}

if ($getModuleName) {
    return $moduleName
}

###################### Removal ######################
if ($rm) {
    Write-Host "Uninstallation mode detected. Removing $projectName..."
    if (Test-Path $targetPath) {
        Write-Host "Removing module at $targetPath"
        Remove-Item -Path $targetPath -Recurse -Force
        Write-Host "$projectName module successfully uninstalled from $targetPath."
    } else {
        Write-Host "$projectName module not found at $targetPath. Nothing to uninstall."
    }

    # Verify removal
    Write-Host "Verifying module removal..."
    if (Get-Module -ListAvailable -Name $projectName) {
        throw "$projectName module still appears in available modules. Please verify manually."
    }
    Write-Host "$projectName module removal verified."
    return 1
}

###################### Installation ######################
Write-Host "Installation mode detected. Installing $projectName module..."
Write-Host "Cleaning target if exists $targetPath"
if (Test-Path($targetPath)) {
    Remove-Item -Path $targetPath -Recurse -Force
}

Write-Host "Copying sources $sourcePath"
Copy-Item -Path $sourcePath -Recurse -Destination $targetPath

Write-Host "Test import module..."
Import-Module $projectName
Write-Host "$projectName module successfully installed to $targetPath."
return