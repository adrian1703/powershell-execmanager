BeforeAll {
    $root = Join-Path $PSScriptRoot "../../PSCmdManager"
    Import-Module($root)
}

Describe 'PSCmdManager Module' {

    BeforeAll {
        $publicFunc    = @( Get-ChildItem -Path (Join-Path $root "Public/*.ps1"        )).Basename
        $privateFunc   = @( Get-ChildItem -Path (Join-Path $root "Private/*.ps1"       )).Basename
        $customActions = @( Get-ChildItem -Path (Join-Path $root "CustomActions/*.ps1" )).Basename
    }

    Context 'on Import-Module' {
        It 'has 3 public functions' {
            $publicFunc.Count | Should -Be 3
        }
        It 'has 2 custom actions' {
            $customActions.Count | Should -Be 2
        }
        It 'exports all public functions and makes them callable' {
            foreach ($f in $publicFunc)
        {
                { & $f -? } | Should -Not -Throw -Because "$f should have been imported"
            }   
        }
        It 'exports all custom actions and makes them callable' {
            foreach ($f in $customActions)
            {
                { & $f -? } | Should -Not -Throw -Because "$f should have been imported"
            }
        }
        It 'does not export any private functions and making them not callable' {
            foreach ($f in $privateFunc)
            {
                { & $f -? } | Should -Throw -Because "$f should not be accessible"
            }
        }
    }
}