# Převodník číselných soustav

CommandLet (Convert-Base): převodník bude umožňovat převádět libovolnou číslenou
soustavu do libovolné číselné soustavy (2 - 36), nikoliv jen mezi základními (2, 8, 10, 16).
Pro ukládaní vstupních a výstupních čísel a práci s nimi je používán datový typ BigInt,
a je tedy zajištěna dostatečná paměťová kapacita pro práci s opravdu velkými čísly.
(Platí však, že čím nižžší soustava, tím menší číslo dokáže reprezantovat.)

## Motivace

Většina konvenčních nástrojů neumožňuje převod mezi nekonvenčními soustavami.

## Funkce

Převod mezi soustavami

Validace vstupu.

Použité přepínače:
  - `-h` nápověda
  - `-n` číslo
  - `-bs` původní soustava čísla
  - `-bt` cílová soustava čísla
  - `-r` raw vstup: n bs bt
  - `-i` interaktivní mód
  - `-Verbose` ukecaný mód
  - `-big` velké znaky výstupu
  - `-t` zobrazí celkový čas výpočtu (Pozor na mód verbose)

## Nápověda

```powershell
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
```

## Instalace

```powershell
$CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
[Environment]::SetEnvironmentVariable("PSModulePath", $CurrentValue + [System.IO.Path]::PathSeparator + "C:\Path\To\This\Repository", "Machine")
```

## Příklady
#### Tisk na konzoli
```powershell
Convert-Base -n FF -bs 16 -bt 2 -big
#Output: 11111111
```

#### Uložení hodnoty do proměnné
```powershell
[string]$val = Convert-Base -n FF -bs 16 -bt 2 -big
Write-Host $val
#Output: 11111111
```

#### String jako parametr
```powershell
Convert-Base -r "FF 16 2" -big
#Output: 11111111
```

#### Interaktivní mód
```powershell
Convert-Base -i
#Please fill in number you want to convert:
FF
#Please fill in source base from which you want to convert the number:
16
#Please fill in target base to which you want to convert the number:
2
#Output: 11111111
```

## Testy
K projektu je přiložen testovací skript obsahující 21 108 testovacích případů, pro ověření funkcionality modulu.

## Referenční nezávislý systém
[www.rapidtables.com](https://www.rapidtables.com/convert/number/base-converter.html)

## Autoři

Dominik Janák, Tomáš Křičenský
