BeforeAll {
    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Convert-PlaceholderToEnvVars.ps1"
    Write-Host $path
    . $path

    $path = Join-Path $PSScriptRoot "../../PSCmdManager/Private/Convert-EnrichStringWithEnvConfig.ps1"
    Write-Host $path
    . $path

    Import-Module powershell-yaml
}
Describe "Convert-EnrichStringWithEnvConfig" {

    It "Iterativly resolves env var that depend on each other" {

        $config = @'
environment:
  - env: "USR"
    val: "${USERPROFILE}"
  - env: "NPP"
    val: "${USR}/npp"
'@
        $cfo = ConvertFrom-Yaml -Yaml $config

        $targetString = '${USR}/npp'
        $expected = "$env:USERPROFILE/npp"
        Convert-EnrichStringWithEnvConfig -t $targetString -cfo $cfo -Verbose | Should -BeExactly $expected
    }
}