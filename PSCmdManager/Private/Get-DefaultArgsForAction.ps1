function Get-DefaultArgsForAction {
    param (
        [Parameter(HelpMessage = "Enter the action-definition object")]
        [Alias("as")]
        [Object] $actionDefinition
    )
    if ($null -eq $actionDefinition)
    {
        return ,@()
    }

    $result = @()
    foreach ($key in $actionDefinition.defaults.Keys)
    {
        $value = $actionDefinition.defaults.$key
        $result += "/$key=$value"
    }
    return ,$result
}
