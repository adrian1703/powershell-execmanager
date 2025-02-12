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
    CompanyName = "Adrian Privat"
}
New-ModuleManifest @moduleSettings