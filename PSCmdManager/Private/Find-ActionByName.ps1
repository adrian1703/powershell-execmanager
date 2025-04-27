function Find-ActionByName
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the action name")]
        [string]$actionName,

        [Parameter(Mandatory = $true, HelpMessage = "Enter the task object containing actions")]
        [Object]$taskObj
    )

    return $taskObj.actions | Where-Object { $_.name -eq $actionName }
}