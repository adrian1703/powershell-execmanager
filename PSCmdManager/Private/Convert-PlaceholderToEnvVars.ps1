function Convert-PlaceholderToEnvVars {
    param (
        [Parameter(HelpMessage = "Enter the run config as parsed object")]
        [Alias("cfo")]
        [Object] $config
    )
    $result = ConvertTo-Yaml $config
    $result = [regex]::replace($result, '\$\{(.*?)\}', {
        param($match)
        $envVarName = $match.Groups[1].Value
        $envVarValue = [System.Environment]::GetEnvironmentVariable($envVarName)
        if ($envVarValue)
        {
            return $envVarValue
        }
        else
        {
            return $match.Value
        }
    })
    return ConvertFrom-Yaml -Yaml $result
}
