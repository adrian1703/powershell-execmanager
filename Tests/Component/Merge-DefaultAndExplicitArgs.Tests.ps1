BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Read-Config.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Get-DefaultArgsForAction.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Get-ExplicitArgsForAction.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Merge-DefaultAndExplicitArgs.ps1"
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

    function Get-ActionAndSchema {
        param (
            [String] $taskName,
            [String] $actionName
        )
        $configPath = Join-Path $PSScriptRoot "../Resources/config-arg-test.yaml"
        Write-Host "Config Path: $configPath"
        $config = Read-Config -configPath $configPath
        Write-Host "Config Type: $( $config.GetType().FullName )"

        # Get the task and action
        $task = $config.tasks | Where-Object { $_.name -eq $taskName }
        if (-not $task) {
            throw "Task '$taskName' not found in configuration."
        }

        $action = $task.actions | Where-Object { $_.name -eq $actionName }
        if (-not $action) {
            throw "Action '$actionName' not found in task '$taskName'."
        }

        # Get the action definition
        $actionType = $action.type
        $actionDefinition = $config."action-definitions".$actionType
        if (-not $actionDefinition) {
            throw "Action definition for type '$actionType' not found in configuration."
        }

        return @{
            Action = $action
            ActionDefinition = $actionDefinition
        }
    }
}

Describe "Merge-DefaultAndExplicitArgs Component Test" {
    It "Should merge default and explicit args from config" {
        # Arrange
        $actionAndSchema = Get-ActionAndSchema "download-task" "download-action"
        $action = $actionAndSchema.Action
        $actionDefinition = $actionAndSchema.ActionDefinition
        
        Write-Host "Action: $($action | ConvertTo-Json -Depth 10)"
        Write-Host "Action Definition: $($actionDefinition | ConvertTo-Json -Depth 10)"
        
        # Act
        $defaultArgs = Get-DefaultArgsForAction -actionDefinition $actionDefinition
        Write-Host "Default Args: $defaultArgs"
        
        $explicitArgs = Get-ExplicitArgsForAction -action $action
        Write-Host "Explicit Args: $explicitArgs"
        
        $mergedArgs = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Merged Args: $mergedArgs"
        
        # Assert
        $mergedArgs | Should -Not -BeNullOrEmpty
        $mergedArgs.Count | Should -Be 3
        $mergedArgs | Should -Contain "/fileName=test.exe"
        $mergedArgs | Should -Contain "/link=https://example.com/test.exe"
        $mergedArgs | Should -Contain "/downloadFolder=$env:TMP"
    }
    
    It "Should override default args with explicit args when keys match" {
        # Arrange - Create a test action with explicit args that override defaults
        $actionAndSchema = Get-ActionAndSchema "download-task" "override-args-action"
        $action = $actionAndSchema.Action
        $actionDefinition = $actionAndSchema.ActionDefinition
        
        # Act
        $defaultArgs = Get-DefaultArgsForAction -actionDefinition $actionDefinition
        Write-Host "Default Args: $defaultArgs"
        
        $explicitArgs = Get-ExplicitArgsForAction -action $action
        Write-Host "Explicit Args: $explicitArgs"
        
        $mergedArgs = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Merged Args: $mergedArgs"
        
        # Assert
        $mergedArgs | Should -Not -BeNullOrEmpty
        $mergedArgs | Should -Contain "/fileName=test.exe"
        $mergedArgs | Should -Contain "/link=https://example.com/test.exe"
        $mergedArgs | Should -Contain "/downloadFolder=C:\CustomFolder"
        $mergedArgs | Should -Not -Contain "/downloadFolder=$env:TMP"
    }
    
    It "Should handle empty default args" {
        # Arrange
        $actionAndSchema = Get-ActionAndSchema "empty-args-task" "no-args-action"
        $action = $actionAndSchema.Action
        $actionDefinition = $actionAndSchema.ActionDefinition
        
        # Act
        $defaultArgs = Get-DefaultArgsForAction -actionDefinition $actionDefinition
        Write-Host "Default Args: $defaultArgs"
        
        $explicitArgs = Get-ExplicitArgsForAction -action $action
        Write-Host "Explicit Args: $explicitArgs"
        
        $mergedArgs = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Merged Args: $mergedArgs"
        
        # Assert
        $mergedArgs.Count | Should -Be 1
    }
    
    It "Should handle empty explicit args" {
        # Arrange
        $actionAndSchema = Get-ActionAndSchema "empty-args-task" "empty-args-action"
        $action = $actionAndSchema.Action
        $actionDefinition = $actionAndSchema.ActionDefinition
        
        # Act
        $defaultArgs = Get-DefaultArgsForAction -actionDefinition $actionDefinition
        Write-Host "Default Args: $defaultArgs"
        
        $explicitArgs = Get-ExplicitArgsForAction -action $action
        Write-Host "Explicit Args: $explicitArgs"
        
        $mergedArgs = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Merged Args: $mergedArgs"
        
        # Assert
        $mergedArgs.Count | Should -Be 1
        $mergedArgs | Should -Contain "/downloadFolder=$env:TMP"
    }
}