#Get public and private function definition files.
$Public        = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
$Private       = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )
$CustomActions = @( Get-ChildItem -Path $PSScriptRoot\CustomActions\*.ps1 -ErrorAction SilentlyContinue )
$ModuleRoot    = $PSScriptRoot

#Dot source the files
Foreach($import in @($Public + $Private + $CustomActions))
{
    Try
    {
        . $import.fullname
    }
    Catch
    {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

Export-ModuleMember -Function @($Public + $CustomActions).Basename

