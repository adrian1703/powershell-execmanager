function Convert-EnrichStringWithEnvConfig
{
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Enter the String to modify")]
        [Alias("t")]
        [string] $target
    ,
        [Parameter(HelpMessage = "Enter the run config as parsed object")]
        [Alias("cfo")]
        [Object] $config
    )
    Write-Verbose "cfo = $config"
    $result = $target
    foreach ($envVar in $config.environment)
    {
        $name = $envVar.env
        $value = $envVar.val
        Write-Verbose "Replacing placeholder for environment variable: $name with value: $value"
        Write-Verbose "Result = $result"
        $result = Convert-PlaceholderToEnvVars -in $result -env $name -val $value
    }
    Write-Verbose "Result = $result"
    return $result
}