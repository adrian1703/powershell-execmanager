BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Merge-DefaultAndExplicitArgs.ps1"
    Write-Host $path
    . $path
}

Describe "Merge-DefaultAndExplicitArgs" {
    It "Returns empty array when both inputs are empty" {
        # Arrange
        $defaultArgs = @()
        $explicitArgs = @()
        Write-Host "Test Case: Both inputs are empty arrays."

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 0
        Write-Host "Test Case assertion passed. Result is an empty array."
    }

    It "Returns default args when explicit args are empty" {
        # Arrange
        $defaultArgs = @("/key1=value1", "/key2=value2")
        $explicitArgs = @()
        Write-Host "Test Case: Default args with empty explicit args."

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 2
        $result | Should -Contain "/key1=value1"
        $result | Should -Contain "/key2=value2"
        Write-Host "Test Case assertion passed. Result contains only default args."
    }

    It "Returns explicit args when default args are empty" {
        # Arrange
        $defaultArgs = @()
        $explicitArgs = @("/key3=value3", "/key4=value4")
        Write-Host "Test Case: Empty default args with explicit args."

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 2
        $result | Should -Contain "/key3=value3"
        $result | Should -Contain "/key4=value4"
        Write-Host "Test Case assertion passed. Result contains only explicit args."
    }

    It "Merges default and explicit args with no overlap" {
        # Arrange
        $defaultArgs = @("/key1=value1", "/key2=value2")
        $explicitArgs = @("/key3=value3", "/key4=value4")
        Write-Host "Test Case: Default and explicit args with no overlap."

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 4
        $result | Should -Contain "/key1=value1"
        $result | Should -Contain "/key2=value2"
        $result | Should -Contain "/key3=value3"
        $result | Should -Contain "/key4=value4"
        Write-Host "Test Case assertion passed. Result contains all args."
    }

    It "Explicit args override default args with same key" {
        # Arrange
        $defaultArgs = @("/key1=default1", "/key2=default2")
        $explicitArgs = @("/key1=explicit1", "/key3=explicit3")
        Write-Host "Test Case: Explicit args override default args with same key."

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 3
        $result | Should -Contain "/key1=explicit1"
        $result | Should -Contain "/key2=default2"
        $result | Should -Contain "/key3=explicit3"
        $result | Should -Not -Contain "/key1=default1"
        Write-Host "Test Case assertion passed. Explicit args override default args with same key."
    }

    It "Handles malformed input gracefully" {
        # Arrange
        $defaultArgs = @("/key1=value1", "malformed-default")
        $explicitArgs = @("/key2=value2", "malformed-explicit")
        Write-Host "Test Case: Malformed input."

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs
        Write-Host "Result: $result"
        Write-Host "Result type: $( $result.GetType().FullName )"

        # Assert
        $result.Count | Should -Be 2
        $result | Should -Contain "/key1=value1"
        $result | Should -Contain "/key2=value2"
        Write-Host "Test Case assertion passed. Malformed input is ignored."
    }
}