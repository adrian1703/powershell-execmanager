function Convert-PlaceholderToEnvVars {
    param (
        [Parameter(Mandatory = $true)]
        [alias("in")]
        [string]$inputString
    )
    $result = [regex]::replace($InputString, '\$\{(.*?)\}', {
        param($match)
        $envVarName = $match.Groups[1].Value
        return [System.Environment]::GetEnvironmentVariable($envVarName)
    })
    return $result
}
