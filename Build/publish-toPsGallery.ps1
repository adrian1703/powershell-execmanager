[System.Environment]::SetEnvironmentVariable("NUGET_CLI_LANGUAGE", "en-us", "Process")
[System.Environment]::SetEnvironmentVariable("DOTNET_CLI_UI_LANGUAGE", "en_US", "Process")

if ($args[0] -eq '-release')
{
    Publish-Module -Path ".\PSCmdManager\" -NuGetApiKey "$env:POWERSHELLGALLARY" -Verbose
}
else
{
    Publish-Module -Path ".\PSCmdManager\" -NuGetApiKey "$env:POWERSHELLGALLARY" -WhatIf -Verbose
}