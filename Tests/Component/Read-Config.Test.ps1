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

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Convert-EnvironmentConfigToEnvVars.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Register-EnvironmentProcessVars.ps1"
    Write-Host $path
    . $path

    Import-Module powershell-yaml
}

function getTestFilePath {
    return Join-Path $PSScriptRoot "/../Resources/config-example-silent-install.yaml"
}

Describe "Silent Install Configuration Tests" {

    #    Context "Read-Config Functionality" {
    #        It "Should throw an error if no parameters are provided" {
    #            # Arrange
    #            $nullConfigPath = $null
    #            $nullConfig = $null
    #
    #            # Act & Assert
    #            { Read-Config -configPath $nullConfigPath -config $nullConfig } | Should -Throw
    #        }

    It "Should parse YAML from file path when configPath is provided" {
        # Arrange
        $mockConfigPath = getTestFilePath
        Write-Host "Test File Path $mockConfigPath"
        # Act
        $parsedConfig = Read-Config -configPath $mockConfigPath -Verbose

        # Assert
        $parsedConfig | Should -Not -BeNullOrEmpty
        $parsedConfig.schema.version | Should -Be 1
    }

#    It "Should handle environments defined in the YAML correctly" {
#        # Arrange
#        $parsedConfig = Read-Config -configPath $testYamlFilePath
#
#        # Act
#        $envConfig = $parsedConfig.environment
#
#        # Assert
#        $envConfig | Should -Not -BeNullOrEmpty
#        $envConfig | Should -Contain @{ env = "USR"; val = "${USERPROFILE}" }
#        $envConfig | Should -Contain @{ env = "NPP"; val = "${USR}/npp" }
#    }
}
