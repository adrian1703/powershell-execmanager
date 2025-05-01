function Get-ExplicitArgsForAction {
    param (
        [Parameter(HelpMessage = "Enter the action-task-object")]
        [Alias("ac")]
        [Object] $action
    )
    $result = @{}
    foreach ($key in $action.args.Keys)
    {
        $value = $action.args.$key
        $result[$key] = $value
    }
    return ,$result
}