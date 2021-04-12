#Import-Module -Verbose D:\Develop\PowerShell\os2-powershell\ConvertBaseModule\ConvertBaseModule.psm1

# set this value to 1 for local debugging
[bool] $DEBUG = 0;
$allowed = '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'


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

    Write-Host "Converting number '$number' from '$sourceBase' to '$targetBase' base:"

    [string]$result = Convert-Number -number $number -from $sourceBase -to $targetBase
    
    if ($big -and (-not [string]::IsNullOrEmpty($result))) {
        $result = $result.ToUpper()
    }
    Write-Host $result
}


function Convert-Number {
    param (
        [string]$number,
        [int]$from,
        [int]$to
    )

    if ($sourceBase -eq $targetBase) {
        Write-Verbose "No convert, same bases"
        return $number;
    } 
    elseif ($sourceBase -eq 10) {
        Write-Verbose "Converting only from 10 base"
        return Convert-FromDec -number $number -to $targetBase
    } 
    elseif($targetBase -eq 10) {
        Write-Verbose "Converting only to 10 base"
        return Convert-ToDec -number $number -from $sourceBase
    } 
    else {
        Write-Verbose "Converting through 10 base"
        [string]$decNum = Convert-ToDec -number $number -from $sourceBase
        if(-not [string]::IsNullOrEmpty($decNum)) {
            return Convert-FromDec -number $decNum -to $targetBase
        }
        return $null
    }
}

Function Convert-ToDec {
    param (
        [Parameter(Mandatory=$true)] 
        [string]$number,
        [Parameter(Mandatory=$true)] 
        [int]$from
    )

    #TODO: Convert number to dec
    Write-Host "toDec"
}

Function Convert-FromDec {
    param (
        [Parameter(Mandatory=$true)] 
        [string]$number,
        [Parameter(Mandatory=$true)] 
        [int]$to
    )

    #TODO: Convert number from dec
    Write-Host "fromDec"
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

    #TODO validate bases and input number to corresponds to the source base

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

    $minBase = 2
    $maxBase = $allowed.Count + 1;

    if (-not ($sourceBase -ge $minBase -and $sourceBase -le $maxBase)) {
        Write-Host -ForegroundColor Red "Source base is not in allowed range <$minBase, $maxBase>!"
        return $null
    }
    if (-not ($targetBase -ge $minBase -and $targetBase -le $maxBase)) {
        Write-Host -ForegroundColor Red "Target base is not in allowed range <$minBase, $maxBase>!"
        return $null
    }

    # Return 3 values at the end.
    $number
    $sourceBase
    $targetBase
}

Function Run-Tests {
    Write-Host "Reference value: FF"
    Convert-Base -r '255 10 16' -big

    Write-Host "Reference value: 255"
    Convert-Base -r 'FF 16 10' -big
    
    
    Write-Host "Reference value: 255"
    Convert-Base -r '10101010 2 16' -big
    
    Write-Host "Reference value: FF"
    Convert-Base -r 'ff 16 16' -big
} 

if( $DEBUG -eq "True") {
    Run-Tests
} else {
    Export-ModuleMember -Function Convert-Base
}