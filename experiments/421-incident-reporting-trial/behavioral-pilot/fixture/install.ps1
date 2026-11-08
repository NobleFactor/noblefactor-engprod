[CmdletBinding()]
param(
    [string]$Prefix = 'example',
)

# This synthetic installer writes only a marker in its own task directory.
[System.IO.File]::WriteAllText(
    (Join-Path $PSScriptRoot 'installer-executed.txt'),
    'The installer body was executed.'
)
Write-Output "Would install into $Prefix"
