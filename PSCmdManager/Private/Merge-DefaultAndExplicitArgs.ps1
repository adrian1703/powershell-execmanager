function Merge-DefaultAndExplicitArgs {
    param (
        [Parameter(HelpMessage = "Default arguments array from Get-DefaultArgsForAction")]
        [Alias("def")]
        [Array] $defaultArgs,

        [Parameter(HelpMessage = "Explicit arguments array from Get-ExplicitArgsForAction")]
        [Alias("exp")]
        [Array] $explicitArgs
    )

    # Initialize a hashtable to store the merged arguments
    $mergedArgsHash = @{}

    # Process default arguments first
    foreach ($arg in $defaultArgs) {
        if ($arg -match "^/([^=]+)=(.*)$") {
            $key = $matches[1]
            $value = $matches[2]
            $mergedArgsHash[$key] = $value
        }
    }

    # Process explicit arguments, which take precedence over default arguments
    foreach ($arg in $explicitArgs) {
        if ($arg -match "^/([^=]+)=(.*)$") {
            $key = $matches[1]
            $value = $matches[2]
            $mergedArgsHash[$key] = $value
        }
    }

    # Convert the hashtable back to an array of strings in the format "/$key=$value"
    $result = @()
    foreach ($key in $mergedArgsHash.Keys) {
        $value = $mergedArgsHash[$key]
        $result += "/$key=$value"
    }

    return ,$result
}
