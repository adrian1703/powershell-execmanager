if ($args[0] -eq '-release')
{
    Publish-Module -Path ".\PSCmdManager\" -NugetAPIKey "$env:POWERSHELLGALLARY" -Verbose
}
else
{
    Publish-Module -Path ".\PSCmdManager\" -NugetAPIKey "$env:POWERSHELLGALLARY" -WhatIf -Verbose
}