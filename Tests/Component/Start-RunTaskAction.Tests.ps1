BeforeAll {
    # Import the entire module from the manifest
    $modulePath = Join-Path $PSScriptRoot "../../PSCmdManager/PSCmdManager.psm1"
    Write-Host "Importing module from: $modulePath"
    Import-Module -Name $modulePath -Force

    # Import the YAML parser module (dependency)
    Import-Module -Name powershell-yaml -Force

    # Helper function to get the path to test configuration
    function getTestFilePath {
        return Join-Path $PSScriptRoot "/../Resources/config-task-test.yaml"
    }
}

Describe "Start-RunTaskAction Function Tests" {
    

    It "Should throw an error if the specified taskName does not exist" {
        # Act & Assert
        { Start-RunTaskAction -configPath (getTestFilePath) -taskName "nonexistent task" -actionName "download-action" -dry } | Should -Throw
    }

    It "Should throw an error if the specified actionName does not exist in the task" {
        # Act & Assert
        { Start-RunTaskAction -configPath (getTestFilePath) -taskName "first task" -actionName "nonexistent-action" -dry } | Should -Throw
    }

    It "Should return the expected command for the 'first task' and 'download-action' in dry run mode" {
        # Act
        $result = Start-RunTaskAction -configPath (getTestFilePath) -taskName "first task" -actionName "download-action" -dry
        # Assert
        $result | Should -Not -BeNullOrEmpty

        # The result should contain "Invoke-Download" followed by a hashtable format
        $result | Should -Match "Invoke-Download"

        # Check each required parameter exists in the output
        $result | Should -Match "downloadFolder\s+C:/DEVELO~1/temp"
        $result | Should -Match "link\s+https://example.com/test.exe"
        $result | Should -Match "fileName\s+test.exe"
    }

    It "Should return the expected command for the 'second task' and 'echo' action in dry run mode" {
        # Act
        $result = Start-RunTaskAction -configPath (getTestFilePath) -taskName "second task" -actionName "echo" -dry

        # Assert
        $result | Should -Not -BeNullOrEmpty

        # Check command name
        $result | Should -Match "Invoke-Exe"

        # Check each required parameter exists in the output
        $result | Should -Match "execArguments\s+{/c, echo, hello, world}"
        $result | Should -Match "fileName\s+cmd\.exe"
        $result | Should -Match "fileLocation\s+C:/Windows/System32"

    }
}