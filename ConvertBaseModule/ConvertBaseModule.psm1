Function Convert-Base {
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, HelpMessage="Show help.")] 
    [switch]$h,

    [Parameter(Mandatory=$false, HelpMessage="Number to convert.")] 
    [string]$n,

    [Parameter(Mandatory=$false, HelpMessage="Input number base.")]
    [AllowNull()]
    [Nullable[System.Int32]]$bs,

    [Parameter(Mandatory=$false, HelpMessage="Output number base.")]
    [AllowNull()]
    [Nullable[System.Int32]]$bt,

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

    $realParameters = Parse-Parameters -n $n -bs $bs -bt $bt -r $r -i $i
    if ($realParameters -eq $null) {
        return
    }
    [string]$number = $realParameters[0]
    [int]$sourceBase = $realParameters[1]
    [int]$targetBase = $realParameters[2]

    # TODO: Real implementation!
    Print-Result "Hello world $number $sourceBase $targetBase" -big $big
}

Function Validate-Input-Parameters {
[OutputType([string])] # Return error message if validation fails, if it passes return null
param (
    [Parameter(Mandatory=$false, HelpMessage="Number to convert.")] 
    [string]$n,

    [Parameter(Mandatory=$false, HelpMessage="Input number base.")]
    [AllowNull()]
    [Nullable[System.Int32]]$bs,

    [Parameter(Mandatory=$false, HelpMessage="Output number base.")]
    [AllowNull()]
    [Nullable[System.Int32]]$bt,

    [Parameter(Mandatory=$false, HelpMessage="Simple raw input (-r 'FF 16 10').")] 
    [string]$r,

    [Parameter(Mandatory=$false, HelpMessage="Interactive input mode.")] 
    [bool]$i
)
    # Raw input enabled.
    if (-not [string]::IsNullOrEmpty($r)) {
        if ((-not [string]::IsNullOrEmpty($n)) -or ($bs -ne $null) -or ($bt  -ne $null) -or $i) {
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

    return $null
}

Function Parse-Parameters {
[OutputType([string], [int], [int])] # Return number, source base and target base in this order (or null if invalid).
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
    [string]$number = $null
    [int]$sourceBase = $null
    [int]$targetBase = $null

    
    # Raw input enabled.
    if (-not [string]::IsNullOrEmpty($r)) {
        [System.Object[]]$raw = $r.Split(' ')
        [string]$rawNumber = $raw[0]
        [string]$rawSourceBase = $raw[1]
        [string]$rawTargetBase = $raw[2]
         
        if ($rawSourceBase -notmatch '^\d+$') {
            Write-Host -ForegroundColor Red 'Source base is not a number!'
            return $null
        }

        if ($rawTargetBase -notmatch '^\d+$') {
            Write-Host -ForegroundColor Red 'Target base is not a number!'
            return $null
        }
        
        $number = $rawNumber
        $sourceBase = $rawSourceBase
        $targetBase = $rawTargetBase

    } elseif ($i) {
        # TODO Interactive input + flags.
    } else {
        # TODO: Input from flags only.
    }

    # TODO: Validate number in range of base characters.
    if ($false) {
        Write-Host -ForegroundColor Red 'Number uses invalid characters for its base!'
        return $null
    }
    if (-not ($sourceBase -ge 2 -and $num -le 36)) {
        Write-Host -ForegroundColor Red 'Source base is not in allowed range <2, 36>!'
        return $null
    }
    if (-not ($targetBase -ge 2 -and $num -le 36)) {
        Write-Host -ForegroundColor Red 'Target base is not in allowed range <2, 36>!'
        return $null
    }

    # Return 3 values at the end.
    $number
    $sourceBase
    $targetBase
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

#Dont change this!
Export-ModuleMember -Function Convert-Base

Convert-Base -r '20 10 16'