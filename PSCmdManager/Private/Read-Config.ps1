function Read-Config {
    param (
        [Parameter(HelpMessage = "Enter the path to run config yaml")]
        [Alias("cfp")]
        [string] $configPath
    ,
        [Parameter(HelpMessage = "Enter the run config as parsed object")]
        [Alias("cfo")]
        [string] $config
    )
    if (-not $config -and -not $configPath)
    {
        throw "You must provide at least one of the following parameters: `-configPath` or `-config`."
    }

    if ($config -eq $null)
    {
        $yamlContent = Get-Content -Raw -Path $configPath
        $yamlContent = Replace-EnvVarsPlaceholders -in $yamlContent
        return ConvertFrom-Yaml -Yaml $yamlContent
    }
    return $config
}