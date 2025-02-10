function Start-RunTaskAllActions {
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
        Write-Host "Running action $cnt from $total : `t${action.name}"
        Start-RunTaskAction -cfo $config -tn $taskName -an $actionName -dry:$dry
    }
}
