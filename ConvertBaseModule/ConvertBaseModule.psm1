#Import-Module -Verbose D:\Develop\PowerShell\os2-powershell\ConvertBaseModule\ConvertBaseModule.psm1

# set this value to 1 for local debugging
[bool] $DEBUG = 0
$allowed = "0123456789abcdefghijklmnopqrstuvwxyz"
#indexes
$values = @{'0'=0;'1'=1;'2'=2;'3'=3;'4'=4;'5'=5;'6'=6;'7'=7;'8'=8;'9'=9;'a'=10;'b'=11;'c'=12;
            'd'=13;'e'=14;'f'=15;'g'=16;'h'=17;'i'=18;'j'=19;'k'=20;'l'=21;'m'=22;'n'=23;'o'=24;
            'p'=25;'q'=26;'r'=27;'s'=28;'t'=29;'u'=30;'v'=31;'w'=32;'x'=33;'y'=34;'z'=35}

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
    [switch]$big,

    [Parameter(Mandatory=$false, HelpMessage="Show computing time in milliseconds.")] 
    [switch]$t
)
    if ($h) {
        Write-Help
        return
    }

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

    Write-Verbose "Converting number '$number' from '$sourceBase' to '$targetBase' base:"
    
    $startMs = (Get-Date).Millisecond

    [string]$result = Convert-Number -number $number -from $sourceBase -to $targetBase
    
    if ($big -and (-not [string]::IsNullOrEmpty($result))) {
        $result = $result.ToUpper()
    }

    $endMs = (Get-Date).Millisecond

    Write-Verbose "Result is '$result'"

    if ($t) {
        Write-Host -ForegroundColor Yellow "This script took $($endMs - $startMs) miliseconds to run"
    }
        
    Write-Verbose "DONE"

    return $result
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
        Write-Verbose "Converting from '$from' through '10' to '$to' base"
        [string]$decNum = Convert-ToDec -number $number -from $sourceBase

        if($DEBUG -eq "True") {
            Write-Host -ForegroundColor Yellow "DEC value is '$decNum'"
        }

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

    Write-Verbose "Converting from '$from' to '10' base"

    [bigint]$sum = 0
    [string]$out = ""

    Write-Verbose "(char_value * base^position) + ..."

    for ($position = 0; $position -lt $number.Length; $position++) {
		$char = $number.SubString($position, 1)
		$index = $number.Length-1 - $position
		$value = $values[$char];
		
		if($value -ge $from) {
			throw "Invalid input value!"
        }
        
        if($DEBUG -eq "True") {
            Write-Host -ForegroundColor Yellow "Use char '$char' at position '$index' with value '$value'"
        }

        [bigint]$power = 1
        for ($i = 0; $i -lt $index; $i++) {
            $power = $power * $from
        }

        $sum += $value * $power;

        if(-not [string]::IsNullOrEmpty($out)) {
            $out = "$out + "
        }
        
        $out += "($value * $from^$index)"
        
    }
    Write-Verbose "$out = $sum"
    Write-Verbose "$number($from) is $sum(10)"
    
    return $sum.ToString();
}

Function Convert-FromDec {
    param (
        [Parameter(Mandatory=$true)] 
        [string]$number,
        [Parameter(Mandatory=$true)] 
        [int]$to
    )

    Write-Verbose "Converting from '10' to '$to' base"
    Write-Verbose "number / base = floor_divide => remainder (converted_char)"

    [bigint]$num = $number;
    [string]$out = "";

    while($num -gt 0) {
        $remainder = $num % $to
        $divide = [bigint]($num / $to)

        $char = $allowed.Substring($remainder, 1)
        $out += $char

        Write-Verbose "$num / $to = $divide => $remainder ($char)"
        $num = $divide
    }

    $reverse = $out[-1..-$out.Length] -join ''
    Write-Verbose "'$out' reverse to '$reverse'"

    Write-Verbose "$number(10) is $reverse($to)"

    return $reverse;
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
    }

    # Interactive mode disabled - require all arguments.
    if (-not $i) {
        if ([string]::IsNullOrEmpty($r) -and ([string]::IsNullOrEmpty($n) -or [string]::IsNullOrEmpty($bs) -or [string]::IsNullOrEmpty($bt))) {
            return 'You need to input all required arguments (number, source base and target base).
Check help for details.'
        }
    }

    Write-Verbose "Input parameters validation success."
    return $null
}

Function Parse-Parameters {
[OutputType([string], [int], [int])] # Return number, source base and target base in this order (or null if invalid).
param (
    [Parameter(Mandatory=$false, HelpMessage="Number to convert.")] 
    [string]$n,

    [Parameter(Mandatory=$false, HelpMessage="Input number base.")]
    [AllowNull()]
    [Nullable[System.Int32]]$bs,

    [Parameter(Mandatory=$false, HelpMessage="Output number base.")]
    [AllowNull()]
    [System.Nullable[System.Int32]]$bt,

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
        if ($raw.Count -ne 3) {
            Write-Host -ForegroundColor Red "Wrong number of arguments for raw input!
You need to provide arguments like this 'numberToConvert sourceBase targetBase'"
            return $null
        }
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
        if ([string]::IsNullOrEmpty($n)) {
            $number = Read-Host -Prompt 'Please fill in number you want to convert'
        } else {
            $number = $n
        }
        if ($bs -eq $null) {
            [System.String]$inputString = Read-Host -Prompt 'Please fill in source base from which you want to convert the number'
            if ($inputString -notmatch '^\d+$') {
                Write-Host -ForegroundColor Red 'Source base is not a number!'
                return $null
            }
            $sourceBase = $inputString
        } else {
            $sourceBase = $bs
        }
        if ($bt -eq $null) {
            [System.String]$inputString = Read-Host -Prompt 'Please fill in target base to which you want to convert the number'
            if ($inputString -notmatch '^\d+$') {
                Write-Host -ForegroundColor Red 'Target base is not a number!'
                return $null
            }
            $targetBase = $inputString
        } else {
            $targetBase = $bt
        }
    } else {
        $number = $n
        $sourceBase = $bs
        $targetBase = $bt
    }

    $minBase = 2
    $maxBase = $allowed.Length;

    if (-not ($sourceBase -ge $minBase -and $sourceBase -le $maxBase)) {
        Write-Host -ForegroundColor Red "Source base is not in allowed range <$minBase, $maxBase>!"
        return $null
    }
    if (-not ($targetBase -ge $minBase -and $targetBase -le $maxBase)) {
        Write-Host -ForegroundColor Red "Target base is not in allowed range <$minBase, $maxBase>!"
        return $null
    }

    # validate input number
    for ($position = 0; $position -lt $number.Length; $position++) {
		$char = $number.SubString($position, 1)
		
		$value = $values[$char];
		
		if($value -notmatch '^\d+$' -or $value -ge $sourceBase) {
			Write-Host -ForegroundColor Red "Input number is not valid for input base '$sourceBase'`nProblem with '$char' at postition $($position+1)"
			return $null
		}
	}

    Write-Verbose 'Input values validation success.'

    # Return 3 values at the end.
    $number
    $sourceBase
    $targetBase
}

Function Write-Help {
    Write-Host '
Usage: Convert-Base [-h] [-n number] [-bs source_base] [-bt target_base]
                    [-r number source_base target_base] [-i] [-Verbose]
                    [-t] [-big]

Options:
    -h             Show help.
    -n             Number to convert.
    -bs base       Input number base.
    -bt base       Output number base.
    -r             Simple raw input (-r "FF 16 10").
    -i             Interactive input mode. 
                   You will be asked to write required arguments during runtime.
    -Verbose       Verbose mode. Shows calculation steps.
    -big           Show output uppercase.
    -t             Show computing time in milliseconds.
'
}

Function Run-Tests {
    Write-Host "Reference value: FF"
    Convert-Base -r '255 10 16' -big


    Write-Host "Reference value: 255"
    Convert-Base -r 'FF 16 10' -big
    
    
    Write-Host "Reference value: AA"
    Convert-Base -r '10101010 2 16' -big
    
    Write-Host "Reference value: FF"
    Convert-Base -r 'ff 16 16' -big
} 

if( $DEBUG -eq "True") {
    Run-Tests
} else {
    Export-ModuleMember -Function Convert-Base
}