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

Describe "Start-RunTaskAllActions Function Tests" {

#    It "Should throw an error if the specified taskName does not exist" {
#        # Act & Assert
#        { Start-RunTaskAllActions -configPath (getTestFilePath) -taskName "nonexistent task" -dry } | Should -Throw
#    }
#
    It "Should execute all actions for 'first task' in dry run mode" {
        # Act
        $results = Start-RunTaskAllActions -configPath (getTestFilePath) -taskName "first task" -dry

        # Assert
        Write-Host "$results"
        $results | Should -Not -BeNullOrEmpty
        $results.Count | Should -Be 2
    }

    It "Should execute all actions for 'second task' in dry run mode" {
        # Act
        $results = Start-RunTaskAllActions -configPath (getTestFilePath) -taskName "second task" -dry

        # Assert
        $results | Should -Not -BeNullOrEmpty
        $results.Count | Should -Be 1

    }

    It "Should pass the config object when provided instead of configPath" {
        # Arrange
        $configContent = Get-Content -Path (getTestFilePath) -Raw
        $config = ConvertFrom-Yaml $configContent

        # Act
        $results = Start-RunTaskAllActions -config $config -taskName "first task" -dry

        # Assert
        $results | Should -Not -BeNullOrEmpty
        $results.Count | Should -Be 2

    }
}
