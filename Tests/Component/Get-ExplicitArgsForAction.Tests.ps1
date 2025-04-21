BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Read-Config.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Get-ExplicitArgsForAction.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Convert-PlaceholderToEnvVars.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Register-EnvironmentProcessVars.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Expand-EnvironmentConfig.ps1"
    Write-Host $path
    . $path

    Import-Module powershell-yaml

    function Get-ActionObject {
        param (
            [String] $taskName,
            [String] $actionName
        )
        # Adjusted path based on the new structure
        $configPath = Join-Path $PSScriptRoot "../Resources/config-arg-test.yaml"
        Write-Host "Config Path: $configPath"
        $config = Read-Config -configPath $configPath
        Write-Host "Config Type: $( $config.GetType().FullName )"

        # Adjusted access pattern for the new schema
        $task = $config.tasks | Where-Object { $_.name -eq $taskName }
        if (-not $task) {
            throw "Task '$taskName' not found in configuration."
        }

        $action = $task.actions | Where-Object { $_.name -eq $actionName }
        if (-not $action) {
            throw "Action '$actionName' not found in task '$taskName'."
        }

        return $action
    }
}

Describe "Get-ExplicitArgsForAction" {
    It "Returns empty array when action has no args" {
        # Arrange
        $action = @{
            name = "test-action"
            # No args property
        }
        Write-Host "Test Case: action has no args. Preparing to execute Get-ExplicitArgsForAction."

        # Act
        $result = Get-ExplicitArgsForAction -action $action
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 0
        Write-Host "Test Case assertion passed. Result is an empty array."
    }

    It "Returns formatted arguments from action args" {
        # Arrange
        $action = Get-ActionObject "download-task" "download-action"
        Write-Host "Test Case: Retrieving action for 'download-task' > 'download-action'."
        Write-Host "Action: $action"
        Write-Host "Action type: $( $action.GetType().FullName )"
        
        # Act
        $result = Get-ExplicitArgsForAction -action $action
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 2
        $result | Should -Contain "/fileName=test.exe"
        $result | Should -Contain "/link=https://example.com/test.exe"
        Write-Host "Test Case assertion passed. Result contains expected formatted arguments."
    }

    It "Handles empty args in action" {
        # Arrange
        $action = Get-ActionObject "empty-args-task" "empty-args-action"
        Write-Host "Test Case: Retrieving action for 'empty-args-task' > 'empty-args-action'. Empty args test."

        # Act
        $result = Get-ExplicitArgsForAction -action $action
        Write-Host "Executed Get-ExplicitArgsForAction. Result: $( $result | Out-String )."

        # Assert
        $result.Count | Should -Be 0
        Write-Host "Test Case assertion passed. Result is an empty array for empty args."
    }

    It "Handles no args field in action" {
        # Arrange
        $action = Get-ActionObject "empty-args-task" "no-args-action"
        Write-Host "Test Case: Retrieving action for 'empty-args-task' > 'empty-args-action'. Empty args test."

        # Act
        $result = Get-ExplicitArgsForAction -action $action
        Write-Host "Executed Get-ExplicitArgsForAction. Result: $( $result | Out-String )."

        # Assert
        $result.Count | Should -Be 0
        Write-Host "Test Case assertion passed. Result is an empty array for empty args."
    }
}