function Register-EnvironmentProcessVars
{
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Enter the run config as parsed object")]
        [Alias("cfo")]
        [Object] $config
    )
    foreach ($envVar in $config.environment)
    {
        $name = $envVar.env
        $value = $envVar.val
        [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
    }
}