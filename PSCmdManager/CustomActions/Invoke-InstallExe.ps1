function Invoke-Exe {
    <#
    .SYNOPSIS
    Executes an executable file with the specified path and arguments.

    .DESCRIPTION
    The `Invoke-Exe` function provides a way to run any executable file. It combines the
    provided file location, file name, and arguments into a single command and invokes
    it. This function is generic and can handle any executable (not limited to installations).

    .PARAMETER fileName
    Specifies the name of the executable file to be executed. This parameter is mandatory.

    .PARAMETER fileLocation
    Specifies the directory path where the executable file is located. This parameter is mandatory.

    .PARAMETER arguments
    Specifies an array of arguments to pass to the executable during execution. This is optional.

    .EXAMPLE
    Invoke-Exe -fileName "app.exe" -fileLocation "C:\Apps" -arguments @("-arg1", "-arg2")
    Runs the executable `app.exe` in the `C:\Apps` folder with arguments `-arg1` and `-arg2`.

    .EXAMPLE
    Invoke-Exe -fileName "example.exe" -fileLocation "D:\Tools" -arguments @("--version")
    Executes `example.exe` in the `D:\Tools` directory and passes the `--version` argument.

    .NOTES
    - Ensure that the path and file name are correct before using this function.
    - The function directly runs the executable, so proper error handling should be implemented externally.
    - Execution permissions might be required for the specified executable file.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the executable filename")]
        [Alias("fn")]
        [string] $fileName
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the file location")]
        [Alias("fl")]
        [string] $fileLocation
    ,
        [Parameter(Mandatory = $false, HelpMessage = "Enter optional arguments for the executable")]
        [Alias("eargs")]
        [Array]$execArguments
    )

    # Build the full path to the executable
    $exeFullPath = Join-Path -Path $fileLocation -ChildPath $fileName

    # Validate that the file exists before attempting to execute it
    if (-Not (Test-Path $exeFullPath)) {
        Write-Error "The file '$exeFullPath' does not exist. Please check the file path."
        return
    }

    # Join arguments into a space-separated string for logging
    $argString = if ($execArguments) { $execArguments -join ' ' } else { '' }

    # Log the command being executed
    Write-Host "Executing command: $exeFullPath $argString"

    # Invoke the executable along with arguments
    try {
        & $exeFullPath @execArguments
        Write-Host "Command executed successfully."
    }
    catch {
        Write-Error "An error occurred while attempting to execute '$exeFullPath': $_"
    }
}