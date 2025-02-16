function Invoke-InstallExe {
    <#
    .SYNOPSIS
    Installs an executable file using the specified path, name, and arguments.

    .DESCRIPTION
    The `Invoke-InstallExe` function automates the execution of an installer executable file.
    It builds the installation command by combining the provided file location, file name, and
    arguments, then invokes the command. Ideal for scripts requiring automated installation
    of software or executables. Note that this function assumes that the installer file exists
    at the provided location and accepts the given arguments.

    .PARAMETER fileName
    Specifies the name of the executable file to be installed. This parameter is mandatory.

    .PARAMETER fileLocation
    Specifies the directory path where the executable file is located. This parameter is mandatory.

    .PARAMETER installArgs
    Specifies an array of arguments to pass to the executable during installation
    (e.g., silent installation flags). This parameter is mandatory.

    .EXAMPLE
    Invoke-InstallExe -fileName "setup.exe" -fileLocation "C:\Installers" -installArgs @("/quiet", "/norestart")
    Runs the installer `setup.exe` located in the `C:\Installers` directory with
    arguments for silent installation and no restart.

    .EXAMPLE
    Invoke-InstallExe -fileName "example.exe" -fileLocation "D:\Softwares" -installArgs @("/install")
    Executes the `example.exe` file located in the `D:\Softwares` directory with the `/install` argument.

    .NOTES
    - Ensure that the path to the installer and file name are correct before running this function.
    - The function does not validate the outcome of the installation; external error handling is recommended.
    - Execution permissions are required for the specified executable file.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download filename")]
        [Alias("fn")]
        [string] $fileName
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the file location")]
        [Alias("fl")]
        [string] $fileLocation
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the installation args")]
        [Alias("ia")]
        [Array]$installArgs
    )
    $installerFullPath = Join-Path $fileLocation + $fileName
    Write-Host "Executing command: $installerFullPath $( $installArgs -join ' ' )"
    & $installerFullPath @installArgs
    Write-Host "Done invoking install command. May or may not be successful."
}