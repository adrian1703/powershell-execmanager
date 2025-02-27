BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Convert-PlaceholderToEnvVars.ps1"
    Write-Host $path
    . $path
}

Describe "Convert-PlaceholderToEnvVars" {

    BeforeAll {
        $env:USERPROFILE = "C:\Users\TestUser"
        $env:TMP = "C:\Temp"
        $env:NPP_DIR = "C:\Program Files\Notepad++"
    }

    It "Replaces Env-Vars without any symbols" {
        $inputString1 = '${USERPROFILE}'
        $expected1 = "$env:USERPROFILE"

        $inputString2 = '${TMP}/Documents/npp'
        $expected2 = "$env:TMP/Documents/npp"

        Convert-PlaceholderToEnvVars -inputString $inputString1 | Should -BeExactly $expected1
        Convert-PlaceholderToEnvVars -inputString $inputString2 | Should -BeExactly $expected2
    }

    It "Replaces Env-Vars with underscores" {
        $inputString1 = 'downloadFolder: ${NPP_DIR}'
        $expected1 = "downloadFolder: $env:NPP_DIR"

        Convert-PlaceholderToEnvVars -inputString $inputString1 | Should -BeExactly $expected1
    }

    It "Does not replace anything if no corresponding Env-Var is found" {
        $inputString1 = 'result = ${ENV_NOT_PRESENT}'
        $expected1 = 'result = ${ENV_NOT_PRESENT}'

        Convert-PlaceholderToEnvVars -inputString $inputString1 | Should -BeExactly $expected1
    }
}