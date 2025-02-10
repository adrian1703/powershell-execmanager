function Invoke-Download
{
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

    Write-Host "Download link: $link"
    Write-Host "Download folder: $downloadFolder"
    Write-Host "Full file path: $fullPath"


    # Ensure target folder exists
    if (!(Test-Path -Path $downloadFolder))
    {
        New-Item -ItemType Directory -Path $downloadFolder | Out-Null
    }
    # delete file if exists
    if (Test-Path -Path $fullPath)
    {
        Write-Host "Existing file found at $fullPath, removing it."
        Remove-Item -Path $fullPath -Force
    }
    # init
    $result = @{
        Status = "Error"
        Path = $fullPath
        Message = "Download failed; the file was not found at the specified path."
    }

    # Attempt to download the file
    try
    {
        Write-Host "Attempting to download the file..."
        Invoke-WebRequest -Uri $link -OutFile $fullPath
        $result = @{
            Status = "Success"
            Path = $fullPath
            Message = "Download complete."
        }
    }
    catch
    {
        Write-Host "Error during file download: $_"
        $result = @{
            Status = "Error"
            Path = $fullPath
            Message = "An error occurred during download: $_"
        }
    }
    # Output the final result as both a message and return value
    Write-Host $result
    return $result
}