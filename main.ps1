Import-Module ConvertBaseModule

Convert-Base



$CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
[Environment]::SetEnvironmentVariable("PSModulePath", $CurrentValue + [System.IO.Path]::PathSeparator + "D:\Skola\os2-powershell", "Machine")