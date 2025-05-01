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

Describe "Start-RunAllTasks Function Tests" {

    It "Should execute all tasks in dry run mode" {
        # Act
        $results = Start-RunAllTasks -configPath (getTestFilePath) -dry

        Write-Host "$($results | Out-String)"

        # Assert
        $results | Should -Not -BeNullOrEmpty
        
        # Check first task's first action result (download-action)
        $results[0] | Should -Match "Invoke-Download"
        $results[0] | Should -Match "/link=https://example.com/test.exe"
        $results[0] | Should -Match "/fileName=test.exe"
        
        # Check first task's second action result (do exe)
        $results[1] | Should -Match "Invoke-Exe"
        $results[1] | Should -Match "/fileName=test.exe"
        
        # Check second task's action result (echo)
        $results[2] | Should -Match "Invoke-Exe"
        $results[2] | Should -Match "/execArguments=/c echo hello world"
        $results[2] | Should -Match "/fileName=cmd.exe"
        $results[2] | Should -Match "/fileLocation=C:/Windows/System32"
    }

    It "Should pass the config object when provided instead of configPath" {
        # Arrange
        $configContent = Get-Content -Path (getTestFilePath) -Raw
        $config = ConvertFrom-Yaml $configContent

        # Act
        $results = Start-RunAllTasks -config $config -dry

        # Assert
        $results | Should -Not -BeNullOrEmpty }
}