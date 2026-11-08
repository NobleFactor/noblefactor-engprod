# Actionable historical lesson

Historical anchor: P002, source row 1 of the saved issue #317 process-violation table. The earlier agent passed a script path to `pwsh -Command` while trying to validate it, which executed the launcher instead.

Before a PowerShell validation step, distinguish parsing from execution. Use `System.Management.Automation.Language.Parser.ParseFile` to inspect syntax without invoking the script. Supplying a path as a command, dot-sourcing the script or using `-File` executes it. Check the parser errors and report only the verification actually performed.

This guidance must affect the validation action and the final claim; naming the historical anchor alone is insufficient.
