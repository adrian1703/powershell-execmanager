function Find-TaskByName {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the execution name")]
        [string]$taskName,
        [Parameter(Mandatory = $true, HelpMessage = "Enter config as parsed object")]
        [Object]$config
    )

    return $config.tasks | Where-Object { $_.name -eq $taskName }
}
