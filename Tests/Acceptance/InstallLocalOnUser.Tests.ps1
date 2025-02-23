$testScriptPath = ".\install-onUser.ps1"  # Path to the script being tested

# Get target path dynamically from the script
$projectName = & $testScriptPath -getModuleName
$targetPath  = & $testScriptPath -getTargetPath

# Ensure environment is clean before running tests
Describe "Module Installation and Removal Tests" {

    BeforeAll {
        # Ensure the environment is clean before starting
        if (Test-Path -Path $targetPath) {
            Remove-Item -Path $targetPath -Recurse -Force
        }

        # Ensure no modules are imported
        if (Get-Module -Name $projectName) {
            Remove-Module -Name $projectName -Force
        }
    }

    Context "Install on Empty Environment" {
        It "Should install the module when no prior installation exists" {
            # Run the install script
            $installResult = & $testScriptPath
            $installResult | Should -BeNullOrEmpty  # Expect no error

            # Verify the module directory exists
            Test-Path -Path $targetPath | Should -Be $true

            # Verify the module is available
            $moduleList = Get-Module -ListAvailable -Name $projectName
            $moduleList | Should -Not -BeNullOrEmpty
        }
    }

    Context "Remove on Empty Environment" {
        It "Should handle removal gracefully when the module is not installed" {
            # Ensure the target path is clear
            if (Test-Path -Path $targetPath) {
                Remove-Item -Path $targetPath -Recurse -Force
            }

            # Run the uninstall script
            $uninstallResult = & $testScriptPath -rm
            $uninstallResult | Should -BeNullOrEmpty  # Expect no error

            # Verify the module directory does not exist
            Test-Path -Path $targetPath | Should -Be $false
        }
    }

    Context "Install on Existing Module" {
        It "Should overwrite an existing installed module" {
            # Ensure module is installed initially
            & $testScriptPath

            # Modify a test file inside the installation to simulate an existing module
            New-Item -Path (Join-Path $targetPath "TestFile.txt") -ItemType File -Force | Out-Null

            # Verify the dummy file exists
            Test-Path -Path (Join-Path $targetPath "TestFile.txt") | Should -Be $true

            # Run the install script again
            $installResult = & $testScriptPath
            $installResult | Should -BeNullOrEmpty  # Expect no error

            # Verify the dummy file was removed (overwrite by install)
            Test-Path -Path (Join-Path $targetPath "TestFile.txt") | Should -Be $false

            # Verify the module is still available
            $moduleList = Get-Module -ListAvailable -Name $projectName
            $moduleList | Should -Not -BeNullOrEmpty
        }
    }

    Context "Install and Remove Module" {
        It "Should install and successfully remove the module" {
            # Run the install script
            $installResult = & $testScriptPath
            $installResult | Should -BeNullOrEmpty  # Expect no error

            # Verify installation
            Test-Path -Path $targetPath | Should -Be $true
            $moduleList = Get-Module -ListAvailable -Name $projectName
            $moduleList | Should -Not -BeNullOrEmpty

            # Run the uninstall script
            $uninstallResult = & $testScriptPath -rm
            $uninstallResult | Should -BeNullOrEmpty  # Expect no error

            # Verify removal
            Test-Path -Path $targetPath | Should -Be $false
            $moduleList = Get-Module -ListAvailable -Name $projectName
            $moduleList | Should -BeNullOrEmpty
        }
    }
}
