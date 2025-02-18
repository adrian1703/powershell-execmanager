# Import the Invoke-Exe function from its location
BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/CustomActions/Invoke-Exe.ps1"
    Write-Host $path
    . $path
}

Describe "Invoke-Exe Tests" {

    Context "Using echo command with cmd.exe" {

        It "Should output the arguments passed to echo" {
            # Arrange: Set up the executable and arguments
            $exeName = "cmd.exe"
            $exeLocation = "C:\Windows\System32"
            $execArguments = @("/c", "echo", "arg1", "arg2", "arg3")

            # Act: Capture the output of the command
            $output = Invoke-Exe -fileName $exeName -fileLocation $exeLocation -execArguments $execArguments | Out-String

            # Assert: Verify the output matches expected
            $output.Trim() | Should -Be "arg1 arg2 arg3"
        }

        It "Should fail if the path to cmd.exe is wrong" {
            # Arrange: Intentionally use an incorrect path
            $exeName = "cmd.exe"
            $exeLocation = "C:\InvalidPath"
            $execArguments = @("/c", "echo", "arg1")

            # Act and Assert: The command should throw an error
            {
                Invoke-Exe -fileName $exeName -fileLocation $exeLocation -execArguments $execArguments
            } | Should -Throw
        }

        It "Should handle empty arguments gracefully" {
            # Arrange: Set up the executable with no arguments
            $exeName = "whoami.exe"
            $exeLocation = "C:\Windows\System32"
            $execArguments = @()

            # Act: Capture the output of the command
            $output = Invoke-Exe -fileName $exeName -fileLocation $exeLocation -execArguments $execArguments | Out-String

            # Assert: Verify the output contains the current user
            $output.Trim() | Should -Match "([A-Za-z0-9\\\-]+)"
        }

        It "Should handle no arguments gracefully" {
            # Arrange: Set up the executable with no arguments
            $exeName = "whoami.exe"
            $exeLocation = "C:\Windows\System32"

            # Act: Capture the output of the command
            $output = Invoke-Exe -fileName $exeName -fileLocation $exeLocation | Out-String

            # Assert: Verify the output contains the current user
            $output.Trim() | Should -Match "([A-Za-z0-9\\\-]+)"
        }
    }
}
