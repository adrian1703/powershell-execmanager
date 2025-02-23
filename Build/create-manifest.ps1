$public = Get-ChildItem -Path (Join-Path $PSScriptRoot "../PSCmdManager/Public") -File | ForEach-Object {
    $_.BaseName
}

$customActions = Get-ChildItem -Path (Join-Path $PSScriptRoot "../PSCmdManager/CustomActions") -File | ForEach-Object {
    $_.BaseName
}


$moduleSettings = @{
    RequiredModules = (@{
        ModuleName="powershell-yaml"
        ModuleVersion="0.4.12";
        GUID="6a75a662-7f53-425a-9777-ee61284407da"
    })
    Path = Join-Path $PSScriptRoot "../PSCmdManager/PSCmdManager.psd1"
    FunctionsToExport = $public + $customActions
    Author = "Adrian Kuhn"
#    CompanyName = "Adrian Privat"
    PowerShellVersion = '5.0'
    ModuleVersion = '0.3.0'
    RootModule = 'PSCmdManager.psm1'
    Description = "A Tool for managing a command workflow using yaml files for configuration. A prime
example would be the deterministic setup of software on a clean instance."
}
New-ModuleManifest @moduleSettings


