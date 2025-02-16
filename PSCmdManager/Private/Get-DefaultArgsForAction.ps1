function Get-DefaultArgsForAction {
    param (
        [Parameter(HelpMessage = "Enter the action-schema object")]
        [Alias("as")]
        [Object] $actionSchema
    )
    $deArgs = @()
    if ($actionSchema -eq $null)
    {
        return $deArgs
    }
    foreach ($key in $actionSchema.defaults.Keys)
    {
        $value = $actionSchema.args.$key
        $deArgs += "/$key=$value"
    }
    return $deArgs
}