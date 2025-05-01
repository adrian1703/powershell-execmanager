BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Merge-DefaultAndExplicitArgs.ps1"
    Write-Host $path
    . $path
}

Describe "Merge-DefaultAndExplicitArgs" {
    It "Returns empty hashtable when both inputs are empty" {
        # Arrange
        $defaultArgs = @{}
        $explicitArgs = @{}

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs

        # Assert
        $result | Should -BeOfType [Hashtable]
        $result.Keys.Count | Should -Be 0
    }

    It "Returns default args when explicit args are empty" {
        # Arrange
        $defaultArgs = @{
            "key1" = "value1"
            "key2" = "value2"
        }
        $explicitArgs = @{}

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs

        # Assert
        $result.Keys.Count | Should -Be 2
        $result["key1"] | Should -Be "value1"
        $result["key2"] | Should -Be "value2"
    }

    It "Returns explicit args when default args are empty" {
        # Arrange
        $defaultArgs = @{}
        $explicitArgs = @{
            "key3" = "value3"
            "key4" = "value4"
        }

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs

        # Assert
        $result.Keys.Count | Should -Be 2
        $result["key3"] | Should -Be "value3"
        $result["key4"] | Should -Be "value4"
    }

    It "Merges default and explicit args with no overlap" {
        # Arrange
        $defaultArgs = @{
            "key1" = "value1"
            "key2" = "value2"
        }
        $explicitArgs = @{
            "key3" = "value3"
            "key4" = "value4"
        }

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs

        # Assert
        $result.Keys.Count | Should -Be 4
        $result["key1"] | Should -Be "value1"
        $result["key2"] | Should -Be "value2"
        $result["key3"] | Should -Be "value3"
        $result["key4"] | Should -Be "value4"
    }

    It "Explicit args override default args with same key" {
        # Arrange
        $defaultArgs = @{
            "key1" = "default1"
            "key2" = "default2"
        }
        $explicitArgs = @{
            "key1" = "explicit1"
            "key3" = "explicit3"
        }

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs

        # Assert
        $result.Keys.Count | Should -Be 3
        $result["key1"] | Should -Be "explicit1"
        $result["key2"] | Should -Be "default2"
        $result["key3"] | Should -Be "explicit3"
    }

    It "Preserves array values in merged result" {
        # Arrange
        $defaultArgs = @{
            "key1" = "default1"
            "array1" = @("item1", "item2")
        }
        $explicitArgs = @{
            "key2" = "explicit2"
            "array2" = @("item3", "item4")
        }

        # Act
        $result = Merge-DefaultAndExplicitArgs -defaultArgs $defaultArgs -explicitArgs $explicitArgs

        # Assert
        $result.Keys.Count | Should -Be 4
        $result["array1"] | Should -Be @("item1", "item2")
        $result["array2"] | Should -Be @("item3", "item4")
    }
}