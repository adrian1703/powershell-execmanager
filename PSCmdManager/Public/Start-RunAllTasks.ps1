function Start-RunAllTasks {
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
