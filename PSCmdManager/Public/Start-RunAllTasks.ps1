function Start-RunAllTasks {
    <#
    .SYNOPSIS
    Executes all tasks defined in the provided configuration.

    .DESCRIPTION
    The `Start-RunAllTasks` function iterates through all tasks specified in the configuration
    and executes each task's actions. The configuration can be passed either via a YAML file
    (`configPath`) or as a parsed object (`config`).

    It also supports a dry-run mode (`-dry`), which simulates the execution without actually
    performing actions.

    Each task is passed to the `Start-RunTaskAllActions` function for execution.

    .PARAMETER configPath
    The path to the YAML configuration file. This file should define the tasks to be executed.

    .PARAMETER config
    A parsed configuration object containing the tasks and their respective actions.
    Use this as an alternative to the `configPath`.

    .PARAMETER dry
    Enables dry-run (test) mode for all tasks. If specified, no actions will be executed, and
    only simulated outputs will be displayed.

    .EXAMPLE
    Start-RunAllTasks -configPath "C:\config\run.yaml"
    Reads the YAML configuration file and runs all tasks defined within it.

    .EXAMPLE
    Start-RunAllTasks -config $myConfig -dry
    Simulates running all tasks from the provided configuration object in dry-run mode.

    .NOTES
    - The `Read-Config` function must be available and properly parse the YAML or object input.
    - The `Start-RunTaskAllActions` function is used to execute all actions for each task.
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
        [Alias("dry")]
        [switch] $dry
    )

    $config = Read-Config $configPath $config
    $tasks  = $config.tasks
    $cnt    = 1
    $total  = $tasks.Count
    foreach ($task in $tasks)
    {
        $taskName = task.name
        Write-Host "Running task $cnt from $total : `t$taskName"
        Start-RunTaskAllActions -cfo $config -tn $taskName -dry:$dry
        $cnt += 1
    }
}
