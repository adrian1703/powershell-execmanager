function Start-RunTaskAction {
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
    $task   = $config.$taskName
    if ($task -eq $null)
    {
        throw "The provided taskName(=$taskName) is not present in config."
    }
    $action = $task.$actionName
    if ($task -eq $null)
    {
        throw "The provided actionName(=$actionName) is not present in task."
    }
    $actionSchema = $config.schema.$actionName
    if ($actionSchema -eq $null)
    {
        throw "The provided actionName(=$actionName) is not present in schema."
    }

    # Gather arguments
    $exArgs  = Get-ExplicitArgsForAction -ac $action
    $deArgs  = Get-DefaultArgsForAction  -as $actionSchema
    $cmdArgs = $exArgs + $deArgs

    # Execution
    $cmdName = $actionSchema.definition.function
    if (-not $dry)
    {
        Write-Host "Running: $cmdName @($cmdArgs -join ' ')"
        & $cmdName @cmdArgs
    }
    else
    {
        Write-Host "Dry run: $cmdName @($cmdArgs -join ' ')"
    }
}