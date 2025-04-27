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

    BeforeEach {
        $configPath = getTestFilePath
        $global:configPath = $configPath # Make available globally for the tests
    }

#    It "Should throw an error if the specified taskName does not exist" {
#        # Act & Assert
#        { Start-RunTaskAction -configPath $configPath -taskName "nonexistent task" -actionName "download-action" -dry } | Should -Throw
#    }
#
#    It "Should throw an error if the specified actionName does not exist in the task" {
#        # Act & Assert
#        { Start-RunTaskAction -configPath $configPath -taskName "first task" -actionName "nonexistent-action" -dry } | Should -Throw
#    }

    It "Should return the expected command for the 'first task' and 'download-action' in dry run mode" {
        # Act
        $result = Start-RunTaskAction -configPath $configPath -taskName "first task" -actionName "download-action" -dry
        Write-Host "$result"
        # Assert
        $result | Should -Be "Invoke-Download @('-fileName', 'test.exe', '-link', 'https://example.com/test.exe', '-downloadFolder', '${TMP}')"
    }

#    It "Should return the expected command for the 'second task' and 'echo' action in dry run mode" {
#        # Act
#        $result = Start-RunTaskAction -configPath $configPath -taskName "second task" -actionName "echo" -dry
#
#        # Assert
#        $result | Should -Be "Invoke-Exe @('-fileName', 'cmd.exe', '-fileLocation', 'C:\Windows\System32', '-execArguments', '/c', 'echo', 'arg1')"
#    }
#
#    It "Should execute the command and return results in non-dry run mode (mocked execution)" {
#        # Arrange
#        Mock Invoke-Download {$null}
#        Mock Invoke-Exe {$null}
#
#        # Act
#        $result = Start-RunTaskAction -configPath $configPath -taskName "first task" -actionName "download-action"
#
#        # Assert
#        Assert-MockCalled Invoke-Download -Exactly 1
#    }
#
#    It "Should not execute but return the command in dry-run mode when dry is true" {
#        # Act
#        $result = Start-RunTaskAction -configPath $configPath -taskName "second task" -actionName "echo" -dry
#
#        # Assert
#        $result -match "^Dry run: Invoke-Exe @" | Should -BeTrue
#    }
}