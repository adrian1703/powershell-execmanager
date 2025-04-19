BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Read-Config.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Get-DefaultArgsForAction.ps1"
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

    function Get-ActionSchema
    {
        param (
            [String] $actionDefinition
        )
        $configPath = Join-Path $PSScriptRoot "/../Resources/config-arg-test.yaml"
        Write-Host "Result: $configPath"
        $config = Read-Config -configPath $configPath
        Write-Host "Result: $( $config.GetType().FullName )"
        return $config."action-definitions".$actionDefinition
    }
}

Describe "Get-DefaultArgsForAction" {
    It "Returns empty array when actionDefinition is null" {
        # Arrange
        $actionDefinition = $null
        Write-Host "Test Case: actionDefinition is null. Preparing to execute Get-DefaultArgsForAction."

        # Act
        $result = Get-DefaultArgsForAction -actionDefinition $actionDefinition
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 0
        Write-Host "Test Case assertion passed. Result is an empty array."
    }

    It "Returns formatted arguments from actionDefinition defaults" {
        # Arrange
        $actionDefinition = Get-ActionSchema "download"
        Write-Host "Test Case: Retrieving actionDefinition for 'download'."
        Write-Host "actionDefinition: $actionDefinition"
        Write-Host "actionDefinition type: $( $actionDefinition.GetType().FullName )"
        # Act
        $result = Get-DefaultArgsForAction -actionDefinition $actionDefinition
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 1
        $result | Should -Contain "/downloadFolder=$env:TMP"
        Write-Host "Test Case assertion passed. Result contains expected formatted arguments."
    }

    It "Handles empty defaults in actionDefinition" {
        $actionDefinition = Get-ActionSchema "download-1"
        Write-Host "Test Case: Retrieving actionDefinition for 'download-1'. Empty defaults test."

        # Act
        $result = Get-DefaultArgsForAction -actionDefinition $actionDefinition
        Write-Host "Executed Get-DefaultArgsForAction. Result: $( $result | Out-String )."

        # Assert
        $result.Count | Should -Be 0
        Write-Host "Test Case assertion passed. Result is an empty array for empty defaults."
    }
}

