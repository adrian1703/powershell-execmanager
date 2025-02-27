function Convert-PlaceholderToEnvVars {
    param (
        [Parameter(Mandatory = $true)]
        [alias("in")]
        [string]$inputString
    ,
        [Parameter()]
        [string]$env
    ,
        [Parameter()]
        [string]$val
    )
    if(-not [string]::IsNullOrEmpty($env) -and -not [string]::IsNullOrEmpty($val))
    {
        [System.Environment]::SetEnvironmentVariable($env, $val, "Process")
    }
    $result = [regex]::replace($InputString, '\$\{(.*?)\}', {
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
    return $result
}
