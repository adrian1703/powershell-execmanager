[string[]]$paths = "$env:PSModulePath" -split ";"
[string]$moduleInstallPath = $null
foreach ($path in $paths)
{
    if ($path -like "*Users*")
    {
        $moduleInstallPath = $path
    }
}
Write-Host $path

$projectName = "PSCmdManager"
$targetPath  = Join-Path $moduleInstallPath $projectName
$sourcePath  = Join-Path (Join-Path $PSScriptRoot  "..") $projectName

Write-Host "Cleaning target if exists $targetPath"
if (Test-Path($targetPath))
{
    Remove-Item -Path $targetPath -Recurse -Force
}

Write-Host "Copying sources $sourcePath"
Copy-Item -Path $sourcePath -Recurse -Destination $targetPath

Write-Host "Test import"
Import-Module $projectName