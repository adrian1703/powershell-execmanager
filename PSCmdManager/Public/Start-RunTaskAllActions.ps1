function Start-RunTaskAllActions {
    <#
    .SYNOPSIS
    Executes all actions for a specified task using the provided run configuration.

    .DESCRIPTION
    The `Start-RunTaskAllActions` function runs all associated actions for the given task,
    as defined in either a YAML configuration file or a parsed configuration object.
    It supports a dry-run mode (`-dry`), which simulates the execution without actually running the actions.

    Either the `configPath` or `config` parameter must be provided to supply the task's configuration.

    .PARAMETER configPath
    The path to the YAML configuration file that defines the task and its actions.

    .PARAMETER config
    A parsed configuration object containing the task definitions and their actions.
    Use this as an alternative to the `configPath`.

    .PARAMETER dry
    Enables dry-run mode for testing. When enabled, it simulates the execution of all task actions
    without actually performing them.

    .PARAMETER taskName
    The name of the task for which all actions must be executed.
    This parameter is mandatory and identifies the task in the configuration.

    .EXAMPLE
    Start-RunTaskAllActions -configPath "C:\config\run.yaml" -taskName "Build"
    Executes all actions for the task "Build" based on the configuration in the YAML file.

    .EXAMPLE
    Start-RunTaskAllActions -config $myConfig -taskName "Deploy" -dry
    Simulates executing all actions for the "Deploy" task using the given configuration object.

    .NOTES
    - Ensure that either `configPath` or `config` is provided for proper execution.
    - This function does not validate individual tasks or actions but assumes proper setup in the configuration.
    #>

    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Enter the path to run config yaml")]
        [Alias("cfp")]
        [string] $configPath
    ,
        [Parameter(HelpMessage = "Enter the run config as parsed object")]
        [Alias("cfo")]
        [Object] $config
    ,
        [Parameter(HelpMessage = "Test Flag; Set to not execute.")]
#        [Alias("dry")]
        [switch] $dry
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the execution task")]
        [Alias("tn")]
        [string]$taskName
    )

    $config = Read-Config $configPath $config
    $task   = $null
    foreach ($item in $config.tasks)
    {
        if ($taskName -eq $item.name)
        {
            $task = $item
            break
        }
    }
    if ($task -eq $null)
    {
        throw "The provided taskName(=$taskName) is not present in config."
    }
    $actions = $task.actions
    $cnt     = 1
    $total   = $actions.Count
    foreach ($action in $actions)
    {
        $actionName = $action.cmd
        Write-Host "Running action $cnt from $total : `t${action.type}"
        Start-RunTaskAction -cfo $config -tn $taskName -an $actionName -dry:$dry
    }
}
