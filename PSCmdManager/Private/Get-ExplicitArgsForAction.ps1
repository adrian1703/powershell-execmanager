function Get-ExplicitArgsForAction {
    param (
        [Parameter(HelpMessage = "Enter the action-task-object")]
        [Alias("ac")]
        [Object] $action
    )
    $exArgs = @()
    foreach ($key in $action.args.Keys)
    {
        $value = $action.args.$key
        $exArgs += "/$key=$value"
    }
    return $exArgs
}