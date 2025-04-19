function Read-Config
{
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Enter the path to run config yaml")]
        [Alias("cfp")]
        [string] $configPath = $null
    ,
        [Parameter(HelpMessage = "Enter the run config as parsed object")]
        [Alias("cfo")]
        [string] $config = $null
    )
    if (-not $config -and -not $configPath)
    {
        throw "You must provide at least one of the following parameters: `-configPath` or `-config`."
    }
    Write-Verbose "Args: configPath: $configPath"
    Write-Verbose "Args: config: $config"
    if (-not $config) {
        Write-Verbose "No config object provided; attempting to read and process config file from path: '$configPath'."

        # First replace sys vars
        Write-Verbose "Reading YAML content from file: '$configPath'."
        $yamlContent = Get-Content -Raw -Path $configPath

        Write-Verbose "Parsing YAML content into a configuration object.: "
        Write-Verbose "$yamlContent"
        $yamlConfig = ConvertFrom-Yaml -Yaml $yamlContent

        Write-Verbose "Replacing system placeholders in config."
        $yamlConfig = Expand-EnvironmentConfig -cfo $yamlConfig

        Write-Verbose "Replacing environment var placeholders with value in config."
        $yamlConfig = Convert-PlaceholderToEnvVars -cfo $yamlConfig

        Write-Verbose "Register process environment vars."
        Register-EnvironmentProcessVars -cfo $yamlConfig

        $yamlContent = ConvertTo-Yaml $yamlConfig
        Write-Verbose "Returning processed configuration object.: $yamlContent"
        return $yamlConfig
    }

    Write-Verbose "Returning pre-parsed config object provided by the caller."
    return $config
}