# Import the Invoke-Exe function from its location
BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/CustomActions/Invoke-Download.ps1"
    Write-Host $path
    . $path
}

# Describe block for the function being tested
Describe "Invoke-Download Tests" {

    BeforeAll {
        $testDownloadFolder   = Join-Path $PSScriptRoot "TestDownloads"
        $testDownloadFileName = "testfile.txt"
        $testDownloadFilePath = Join-Path -Path $testDownloadFolder -ChildPath $testDownloadFileName
        $testUrl              = "https://github.com/github/gitignore/raw/main/README.md"
        $invalidUrl           = "https://nonexistent.url/file.txt"
        # Clean up the test folder before running the tests
        if (Test-Path -Path $testDownloadFolder) {
            Remove-Item -Path $testDownloadFolder -Recurse -Force
        }
    }

    AfterAll {
        # Cleanup test folder after the tests complete
        if (Test-Path -Path $testDownloadFolder) {
            Remove-Item -Path $testDownloadFolder -Recurse -Force
        }
    }

    Context "Successful File Download" {

        It "Should successfully download a file" {
            # Act: Call Invoke-Download
            $result = Invoke-Download -link $testUrl -fileName $testDownloadFileName -downloadFolder $testDownloadFolder

            # Assert: Validate the status and file existence
            $result.Status | Should -Be "Success"
            Test-Path -Path $testDownloadFilePath | Should -Be $true
        }

        It "Should create the target folder if it does not exist" {
            # Arrange: Delete the test folder to ensure it doesn't exist
            if (Test-Path -Path $testDownloadFolder) {
                Remove-Item -Path $testDownloadFolder -Recurse -Force
            }

            # Act: Call Invoke-Download
            Invoke-Download -link $testUrl -fileName $testDownloadFileName -downloadFolder $testDownloadFolder

            # Assert: Validate that the folder is created
            Test-Path -Path $testDownloadFolder | Should -Be $true
        }
    }

    Context "Failed File Download" {

        It "Should throw an error when the URL is invalid" {
            # Act & Assert: Ensure the function throws an error
            {
                Invoke-Download -link $invalidUrl -fileName $testDownloadFileName -downloadFolder $testDownloadFolder
            } | Should -Throw
        }

        It "Should not leave behind a file when the download fails" {
            # Act: Attempt to invoke the download and handle the error
            try {
                Invoke-Download -link $invalidUrl -fileName $testDownloadFileName -downloadFolder $testDownloadFolder
            } catch {
                # Do nothing
            }

            # Assert: Validate the file does not exist
            Test-Path -Path $testDownloadFilePath | Should -Be $false
        }
    }

    Context "Existing File Overwrite" {

        It "Should overwrite an existing file if it already exists" {
            New-Item -ItemType File -Path $testDownloadFilePath -Force | Out-Null
            $existingContent = Get-Content -Path $testDownloadFilePath

            # Act: Download the file (should overwrite the existing one)
            Invoke-Download -link $testUrl -fileName $testDownloadFileName -downloadFolder $testDownloadFolder

            # Assert: Validate the file is overwritten
            Test-Path -Path $testDownloadFilePath | Should -Be $true
            $newContent = Get-Content -Path $testDownloadFilePath

            # Verify that the content has changed
            $newContent | Should -Not -Be $existingContent
        }
    }
}

