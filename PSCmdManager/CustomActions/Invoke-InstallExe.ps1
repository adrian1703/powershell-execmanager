function Invoke-InstallExe
{
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download filename")]
        [Alias("fn")]
        [string] $fileName
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the file location")]
        [Alias("fl")]
        [string] $fileLocation
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the installation args")]
        [Alias("ia")]
        [Array]$installArgs
    )
    $installerFullPath = Join-Path $fileLocation + $fileName
    Write-Host "Executing command: $installerFullPath $( $installArgs -join ' ' )"
    & $installerFullPath @installArgs
    Write-Host "Done invoking install command. May or may not be successful."
}