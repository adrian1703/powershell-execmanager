BeforeAll {
    # Dependency: Load required functions and modules
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

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Find-TaskByName.ps1"
    Write-Host $path
    . $path

    # Load Find-ActionByName (main function being tested)
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Find-ActionByName.ps1"
    Write-Host $path
    . $path

    Import-Module powershell-yaml

    # Helper function to get the test YAML file path
    function getTestFilePath {
        return Join-Path $PSScriptRoot "/../Resources/config-task-test.yaml"
    }
}

Describe "Action Finder Tests" {

    It "Should find an action by name when it exists in a task" {
        # Arrange
        $configPath = getTestFilePath
        $parsedConfig = Read-Config -configPath $configPath

        # Find the task that contains the action
        $taskObj = Find-TaskByName -taskName "first task" -config $parsedConfig
        # Act
        $action = Find-ActionByName -actionName "download-action" -taskObj $taskObj
        # Assert
        $action | Should -Not -BeNullOrEmpty
        $action.name | Should -Be "download-action"
        $action.type | Should -Be "download"
        $action.args | Should -Not -BeNullOrEmpty
    }

    It "Should find an action by name when it exists in a task2" {
        # Arrange
        $configPath = getTestFilePath
        $parsedConfig = Read-Config -configPath $configPath

        # Find the task that contains the action
        $taskObj = Find-TaskByName -taskName "second task" -config $parsedConfig

        # Act
        $action = Find-ActionByName -actionName "echo" -taskObj $taskObj
        Write-Host "Attempted to find nonexistent action. Result: $($action | Out-String)"
        # Assert
        $action | Should -Not -BeNullOrEmpty
        $action.name | Should -Be "echo"
        $action.type | Should -Be "cmd"
        $action.args | Should -Not -BeNullOrEmpty
    }

    It "Should return null if the action does not exist in the task" {
        # Arrange
        $configPath = getTestFilePath
        $parsedConfig = Read-Config -configPath $configPath

        # Find the task that might contain the action
        $taskObj = Find-TaskByName -taskName "first task" -config $parsedConfig

        # Act
        $action = Find-ActionByName -actionName "nonexistent-action" -taskObj $taskObj

        # Assert
        $action | Should -BeNullOrEmpty
    }

    It "Should return null if the task that might contain the action does not exist" {
        # Arrange
        $configPath = getTestFilePath
        $parsedConfig = Read-Config -configPath $configPath

        # Act
        $taskObj = Find-TaskByName -taskName "nonexistent-task" -config $parsedConfig

        $action = $null
        if ($taskObj -ne $null) {
            $action = Find-ActionByName -actionName "any-action" -taskObj $taskObj
        }

        # Assert
        $taskObj | Should -BeNullOrEmpty
        $action | Should -BeNullOrEmpty
    }

    It "Should throw an error if no args are provided" {
        # Act & Assert
        { Find-ActionByName -actionName $null -taskObj $null } | Should -Throw
    }
}