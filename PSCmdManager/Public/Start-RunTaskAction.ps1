function Start-RunTaskAction {
    <#
    .SYNOPSIS
    Executes a specified task action based on the provided run configuration.

    .DESCRIPTION
    The `Start-RunTaskAction` function is designed to execute specific tasks
    based on the provided YAML configuration file or parsed configuration object.
    It supports dry-run mode for testing and requires both task name and action name.

    .PARAMETER configPath
    The path to the YAML configuration file to run. Use this parameter if
    the configuration is not passed as an object.

    .PARAMETER config
    The parsed configuration object. Use as an alternative to the `configPath`.

    .PARAMETER dry
    Enables dry-run mode (test mode) where execution is simulated but no actual
    actions are performed.

    .PARAMETER taskName
    Specifies the name of the task to be executed. This parameter is mandatory.

    .PARAMETER actionName
    Specifies the action of the task to be performed. This parameter is mandatory.

    .EXAMPLE
    Start-RunTaskAction -configPath "C:\config\run.yaml" -taskName "Build" -actionName "Start"
    Executes the "Start" action for the "Build" task using the YAML configuration file.

    .EXAMPLE
    Start-RunTaskAction -config $myConfig -taskName "Deploy" -actionName "Stop" -dry
    Simulates stopping the "Deploy" task using the provided configuration object.

    .NOTES
    This function assumes that either `configPath` or `config` is provided for execution.
    It does not validate the actions of tasks but expects a functional setup.
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
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the action of task")]
        [Alias("an")]
        [string]$actionName
    )

    # Validating
    $config = Read-Config $configPath $config
    $task = Find-TaskByName -taskName $taskName -config $config
    Write-Verbose "Task: $($task | Out-String)"
    if ($task -eq $null)
    {
        throw "The provided taskName(=$taskName) is not present in config."
    }
    $action = Find-ActionByName -actionName $actionName -taskObj $task
    Write-Verbose "Action: $($action | Out-String)"
    if ($action -eq $null)
    {
        throw "The provided actionName(=$actionName) is not present in task."
    }
    $type = $action.type
    $actionSchema = $config."action-definitions".$type
    if ($actionSchema -eq $null)
    {
        throw "The provided type(=$type) is not present in schema."
    }

    # Gather arguments
    $exArgs  = Get-ExplicitArgsForAction -ac $action
    $deArgs  = Get-DefaultArgsForAction  -as $actionSchema
    $cmdArgs = Merge-DefaultAndExplicitArgs -defaultArgs $deArgs -explicitArgs $exArgs

    # Execution
    $cmdName = $actionSchema.definition.function
    $logString = "$cmdName " + $cmdArgs -join ' '
    if (-not $dry)
    {
        Write-Host "Running: $logString"
        $result = & $cmdName @cmdArgs
        return $result
    }
    else
    {
        Write-Host "Dry run: $logString"
        return $logString
    }
}
