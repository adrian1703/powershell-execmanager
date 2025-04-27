BeforeAll {
    # Dependency
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Read-Config.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Get-DefaultArgsForAction.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Convert-PlaceholderToEnvVars.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Expand-EnvironmentConfig.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Register-EnvironmentProcessVars.ps1"
    Write-Host $path
    . $path

    #Main
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Find-TaskByName.ps1"
    Write-Host $path
    . $path

    Import-Module powershell-yaml

    # Helper function to get test YAML file path
    function getTestFilePath {
        return Join-Path $PSScriptRoot "/../Resources/config-task-test.yaml"
    }
}

Describe "Task Finder Tests" {

    It "Should find a task by name when the task exists" {
        # Arrange
        $configPath = getTestFilePath
        $parsedConfig = Read-Config -configPath $configPath

        # Act
        $task = Find-TaskByName -taskName "first task" -config $parsedConfig

        # Assert
        $task | Should -Not -BeNullOrEmpty
        $task.name | Should -Be "first task"
        $task.actions | Should -Not -BeNullOrEmpty
        $task.actions.Count | Should -Be 2
    }

    It "Should find a different task by name when the task exists" {
        # Arrange
        $configPath = getTestFilePath
        $parsedConfig = Read-Config -configPath $configPath

        # Act
        $task = Find-TaskByName -taskName "second task" -config $parsedConfig

        # Assert
        $task | Should -Not -BeNullOrEmpty
        $task.name | Should -Be "second task"
        $task.actions | Should -Not -BeNullOrEmpty
        $task.actions.Count | Should -Be 1
        $task.actions[0].name | Should -Be "echo"
    }

    It "Should return null if the task does not exist" {
        # Arrange
        $configPath = getTestFilePath
        $parsedConfig = Read-Config -configPath $configPath

        # Act
        $task = Find-TaskByName -taskName "nonexistent task" -config $parsedConfig

        # Assert
        $task | Should -BeNullOrEmpty
    }
}
