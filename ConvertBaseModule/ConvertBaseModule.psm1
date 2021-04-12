Function Convert-Base {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, HelpMessage="Show help.")] 
    [switch]$h,

    [Parameter(Mandatory=$false, HelpMessage="Number to convert.")] 
    [string]$n,

    [Parameter(Mandatory=$false, HelpMessage="Input number base.")] 
    [int]$bs,

    [Parameter(Mandatory=$false, HelpMessage="Output number base.")] 
    [int]$bt,

    [Parameter(Mandatory=$false, HelpMessage="Simple raw input (-r 'FF 16 10').")] 
    [string]$r,

    [Parameter(Mandatory=$false, HelpMessage="Interactive input mode. You will be asked to write required arguments during runtime.")] 
    [switch]$i,

    [Parameter(Mandatory=$false, HelpMessage="Verbose mode. Shows calculation steps.")] 
    [switch]$v,

    [Parameter(Mandatory=$false, HelpMessage="Show output uppercase.")] 
    [switch]$big
)

    # TODO: BODY!
    Print-Result 'Hello world' -big $big
}

Function Print-Result {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, HelpMessage="Text to print.")] 
    [string]$text,

    [Parameter(Mandatory=$false, HelpMessage="Show output uppercase.")] 
    [bool]$big
)
    if ($big) {
        $text = $text.ToUpper()
    }
    Write-Host $text
} 
