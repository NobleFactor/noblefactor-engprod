[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string]$Path
)

$Tokens = $null
$ParseErrors = $null
$Ast = [System.Management.Automation.Language.Parser]::ParseFile(
    (Resolve-Path -LiteralPath $Path).Path,
    [ref]$Tokens,
    [ref]$ParseErrors
)

[pscustomobject]@{
    SyntaxValid = $ParseErrors.Count -eq 0
    ParameterNames = @($Ast.ParamBlock.Parameters | ForEach-Object { $_.Name.VariablePath.UserPath })
    Errors = @($ParseErrors | ForEach-Object { $_.Message })
} | ConvertTo-Json -Depth 4

if ($ParseErrors.Count -gt 0) {
    exit 1
}
