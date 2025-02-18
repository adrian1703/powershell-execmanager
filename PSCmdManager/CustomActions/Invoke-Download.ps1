function Invoke-Download {
    <#
    .SYNOPSIS
    Downloads a file from a specified URL and saves it to a target folder.

    .DESCRIPTION
    The `Invoke-Download` function automates downloading files from the provided URL and
    saves them to a target folder with the specified file name. If the folder does not exist,
    it is created automatically. If a file with the same name already exists, it is deleted
    before the new file is downloaded. The function returns the status of the download,
    including the file path and any errors encountered during the process.

    .PARAMETER link
    Specifies the URL of the file to be downloaded. This parameter is mandatory.

    .PARAMETER fileName
    Specifies the name of the file to be saved. If not provided, the file name is automatically
    derived from the URL. This parameter is mandatory.

    .PARAMETER downloadFolder
    Specifies the target folder where the file should be downloaded. If the folder does not exist,
    it will be created. This parameter is mandatory.

    .EXAMPLE
    Invoke-Download -link "https://example.com/file.zip" -fileName "file.zip" -downloadFolder "C:\Downloads"
    Downloads the file from the given URL and saves it as `file.zip` in the `C:\Downloads` folder.

    .EXAMPLE
    Invoke-Download -link "https://example.com/app.exe" -fileName "installer.exe" -downloadFolder "D:\Installers"
    Downloads the `app.exe` file from the URL and saves it as `installer.exe` in the `D:\Installers` folder.
    If the `D:\Installers` folder does not exist, it is created automatically.

    .NOTES
    - The function uses `Invoke-WebRequest` for downloading files, so ensure you are running in a
      PowerShell environment where this cmdlet is available.
    - Errors are handled gracefully, and the function will return a structured result object
      with status, file path, and an error message if applicable.
    - Proper internet connectivity and permissions to write to the download folder are required.

    .OUTPUTS
    Returns a custom object containing:
        - Status: "Success" or "Error"
        - Path: The full path to the downloaded file
        - Message: A message indicating the outcome of the download operation.
    #>
    [CmdletBinding()]

    param (
    # Mandatory
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download link")]
        [Alias("dl")]
        [string] $link
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download filename")]
        [Alias("fn")]
        [string] $fileName
    ,
        [Parameter(Mandatory = $true, HelpMessage = "Enter the download folder")]
        [Alias("df")]
        [string] $downloadFolder
    )

    if ($fileName -eq $null)
    {
        $fileName = Split-Path -Path $link -Leaf
    }
    $fullPath = Join-Path $downloadFolder $fileName

    Write-Verbose "Download link: $link"
    Write-Verbose "Download folder: $downloadFolder"
    Write-Verbose "Full file path: $fullPath"


    # Ensure target folder exists
    if (!(Test-Path -Path $downloadFolder))
    {
        New-Item -ItemType Directory -Path $downloadFolder | Out-Null
    }
    # delete file if exists
    if (Test-Path -Path $fullPath)
    {
        Write-Verbose "Existing file found at $fullPath, removing it."
        Remove-Item -Path $fullPath -Force
    }

    # Attempt to download the file
    try
    {
        Write-Verbose "Attempting to download the file..."
        Invoke-WebRequest -Uri $link -OutFile $fullPath
        $result = @{
            Status = "Success"
            Path = $fullPath
            Message = "Download complete."
        }
    }
    catch
    {
        # Fail explicitly with an error message
        $errorMessage = "An error occurred during download: $($_.Exception.Message)"
        Write-Error $errorMessage
        throw $errorMessage  # Stop the script execution with the error
    }
    # Output the final result as both a message and return value
    Write-Verbose $result
    return $result
}