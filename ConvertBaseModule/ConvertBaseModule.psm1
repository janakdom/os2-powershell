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
    # Validate input.
    $validationResult = Validate-Input-Parameters -n $n -bs $bs -bt $bt -r $r -i $i
    if ($validationResult -ne $null) {
        Write-Host $validationResult -ForegroundColor Red
        return
    }

    # TODO: BODY!
    Print-Result 'Hello world' -big $big
}
Function Validate-Input-Parameters {
[OutputType([string])] # Return error message if validation fails, if it passes return null
param (
    [Parameter(Mandatory=$false, HelpMessage="Number to convert.")] 
    [string]$n,

    [Parameter(Mandatory=$false, HelpMessage="Input number base.")] 
    [int]$bs,

    [Parameter(Mandatory=$false, HelpMessage="Output number base.")] 
    [int]$bt,

    [Parameter(Mandatory=$false, HelpMessage="Simple raw input (-r 'FF 16 10').")] 
    [string]$r,

    [Parameter(Mandatory=$false, HelpMessage="Interactive input mode.")] 
    [bool]$i
)
    # Raw input enabled.
    if (-not [string]::IsNullOrEmpty($r)) {
        if ((-not [string]::IsNullOrEmpty($n)) -or (-not [string]::IsNullOrEmpty($bs)) -or (-not [string]::IsNullOrEmpty($bt)) -or $i) {
            return 'Do not use other input methods while using RAW input!'
        }

        # TODO: Validate Raw input string.
    }

    # Interactive mode disabled - require all arguments.
    if (-not $i) {
        if ([string]::IsNullOrEmpty($r) -and ([string]::IsNullOrEmpty($n) -or [string]::IsNullOrEmpty($bs) -eq [string]::IsNullOrEmpty($bt))) {
            return 'You need to input all required arguments (number, source base and target base).
Check help for details.'
        }
    }

    # TODO: Validate numbers/Input.

    return $null
}


Function Print-Result {
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

Convert-Base