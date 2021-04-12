# Převodník číselných soustav

CommandLet (Convert-Base): převodník bude umožňovat převádět libovolnou číslenou 
soustavu do libovolné číselné soustavy (2 - 36), nikoliv jen mezi základními (2, 8, 10, 16).
Pro převod bude využívat 

## Motivace

Většina konvenčních nástrojů neumožňuje převod mezi nekonvenčními soustavami.

## Funkce

Převod mezi soustavami

Validace vstupu. 

Použité přepínače:
  - `-h` nápověda
  - `-n` číslo
  - `-bs` soustava čísla
  - `-bt` soustava čísla 2
  - `-r` raw vstup: n bs bt
  - `-i` interkaktivní mód
  - `-v` ukecaný mód
  - `-big` velké znaky výstupu
  - `-t` zobrazí celkový čas výpočtu (Pozor na mód verbose)

## Nápověda

```powershell
Usage: Convert-Base [-h] [-n number] [-bs source_base] [-bt target_base]
                    [-r number source_base target_base] [-i] [-v] [-big]

Options:
    -h             Show help.
    -n             Number to convert.
    -bs base       Input number base.
    -bt base       Output number base.
    -r             Simple raw input (-r "FF 16 10").
    -i             Interactive input mode. 
                   You will be asked to write required arguments during runtime.
    -v             Verbose mode. Shows calculation steps.
    -big           Show output uppercase.
	-t             Show computing time in milliseconds.
```

## Instalace

```powershell
$CurrentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
[Environment]::SetEnvironmentVariable("PSModulePath", $CurrentValue + [System.IO.Path]::PathSeparator + "C:\Path\To\This\Repository", "Machine")
```


## Autoři

Dominik Janák, Tomáš Křičenský
