BeforeAll {
    # Import the entire module from the manifest
    $modulePath = Join-Path $PSScriptRoot "../../PSCmdManager/PSCmdManager.psm1"
    Write-Host "Importing module from: $modulePath"
    Import-Module -Name $modulePath -Force

    # Import the YAML parser module (dependency)
    Import-Module -Name powershell-yaml -Force

    # Helper function to get the path to test configuration
    function getExamplesFolderPath {
        return Join-Path $PSScriptRoot "/../../Examples/"
    }
}

Describe "Example Tests should run" {

    It "Echo test" {
        # Act
        $path = Join-Path (getExamplesFolderPath) "invoking-other-functions-using-Invoke-Exe.yaml"
        $results = Start-RunAllTasks -configPath $path
        Write-Host $results
    }
}