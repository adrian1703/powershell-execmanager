function Expand-EnvironmentConfig {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Enter the run config as parsed object")]
        [Alias("cfo")]
        [Object] $config
    )
    $result = ConvertTo-Yaml $config
    $resultOld = ""
    while (-not ($result -eq $resultOld))
    {
        $resultOld = $result
        foreach ($envVar in $config.environment)
        {
            $name   = $envVar.env
            $value  = $envVar.val
            Write-Verbose "Replacing placeholder for environment variable: $name with value: $value"
            $result = $result.Replace('${' + $name + '}', $value)
            Write-Verbose "Result = $result"
        }
        $config = ConvertFrom-Yaml -Yaml $result
    }

    return $config
}