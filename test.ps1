Import-Module D:\Develop\PowerShell\os2-powershell\ConvertBaseModule\ConvertBaseModule.psm1

# minimum tests are 2!!
$tests = @(
        @('5SD4FG65SDF4G65D4FG6DF7G87VDF8SG7V2D68F27VGD8F7G268DF4', 36, 2, '1011100111111100111011111000011111011001010010110010011111111010010101100101100100111111110111100001100110100010011001100100010011000010101101100111001110010000010011111000111000111011110101111000011001001100101001101010110001100111100010101101000000110100110001100001111110000'),
        @('1011', 2, 16, 'B')
    );

[int]$cnt = 0;
[int]$err = 0;
[int]$cntTests = $tests.length;
[bool]$clear = $true;
 
Write-Host -ForegroundColor Yellow "Starting $($cntTests) tests..."

Write-Host $tests

foreach ($test in $tests)
{
  $input = $test[0]
  $bs = $test[1]
  $bt = $test[2]
  $ref = $test[3]

  [string]$res = Convert-Base -n $input -bs $bs -bt $bt -big

  if($ref -ne $res) {
    Write-Host -ForegroundColor Red "ERROR: Converted number '$($input)' in $($bs) to $($bt) base is incorrect!`n         Output:     $($res)`n         Reference:  $($ref)"
    $clear = $false
    Convert-Base -n $input -bs $bs -bt $bt -big -Verbose

    $err++;
  }
  

  $cnt++
  $perc = ([int]($cnt / $cntTests * 100))
  Write-Progress -Activity "Running $($cntTests) tests..." -Status "$($perc)% Complete" -PercentComplete $perc ;
  
}

if($err -gt 0) {
    Write-Host -ForegroundColor Red "$($err) tests errored..."
    Write-Host -ForegroundColor Green "$($cnt-$err) tests passed..."
} else {
    Write-Host -ForegroundColor Green "ALL $($cnt) tests passed..."
}