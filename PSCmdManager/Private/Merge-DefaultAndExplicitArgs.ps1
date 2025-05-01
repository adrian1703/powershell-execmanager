function Merge-DefaultAndExplicitArgs {
    [CmdletBinding()]
    param (
        [Parameter(HelpMessage = "Default arguments array from Get-DefaultArgsForAction")]
        [Alias("def")]
        [Hashtable] $defaultArgs,

        [Parameter(HelpMessage = "Explicit arguments array from Get-ExplicitArgsForAction")]
        [Alias("exp")]
        [Hashtable] $explicitArgs
    )
    Write-Verbose "Merging default and explicit arguments"
    Write-Verbose "  Default args count: $($defaultArgs.Keys.Count)"
    Write-Verbose "  Explicit args count: $($explicitArgs.Keys.Count)"

    $result = @{}

    # Process default arguments first
    foreach ($key in $defaultArgs.Keys) {
        $value = $defaultArgs[$key]
        Write-Verbose "  Adding default arg: $key = $($value | ConvertTo-Json -Compress)"
        $result[$key] = $value
    }

    # Process explicit arguments
    foreach ($key in $explicitArgs.Keys) {
        $oldValue = if ($result.ContainsKey($key)) { $result[$key] } else { "<none>" }
        $newValue = $explicitArgs[$key]
        Write-Verbose "  Overriding arg: $key = $($newValue | ConvertTo-Json -Compress) (was: $oldValue)"
        $result[$key] = $newValue
    }


    return ,$result
}
