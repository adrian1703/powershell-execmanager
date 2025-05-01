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
        $results.Count | Should -Be 3
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