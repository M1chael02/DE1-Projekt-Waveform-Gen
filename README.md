# DE1-Projekt-Waveform-Gen
Jednoduchý generátor průběhů signálu s využitím vývojové desky Nexys A7-50T ve VHDL
## Členové týmu
- Michael Jurča ([M1chael02](https://github.com/M1chael02)) - pilový průběh, správa repozitáře
- Denis Kaňovský ([profesorPrymula](https://github.com/profesorPrymula)) - trojúhelníkový průběh, dokumentace
- Dominik Nádvorník ([nadvornikdominik](https://github.com/nadvornikdominik)) - obdélníkový průběh, top level design

## Obsah
- [Základní popis fungování](#Základní-popis-fungování)
- [Top level design](#Top-level-design)
- [I/O sekce](#IO-sekce)
- [Moduly](#Moduly)
- [Simulace](#Simulace)
- [Výstupní filtr](#Vystupni-filtr)
- [Závěr](#Závěr)

## Základní popis fungování
Funkční generátor je druh generátoru, který umí na výstupu generovat různé tvary signálů. Náš projekt se bude zabývat třemi průběhy, a to obdélníkovým, trojúhelníkovým a harmonickým.

Celý projekt využívá 7-segmentovku k zobrazení nastaveného kmitočtu výstupu. Následně využívá tří výstupních pinů pro tři průběhy. Také se počítá s pěti tlačítky pro obsluhu přístroje.

Každý z tvarů má vlastní výstup, a to z důvodu potřeby různých rekonstrukčních filtrů pro každý z tvarů.

Frekvence je indikováná pomocí třetí až osmé 7-segmentovky přímo v Hz. Nejvyšší možné rozlišení je 1Hz. 

Frekvence výstupního signálu se volí pomocí tlačítek vpravo(+) a vlevo(-), řád se mění pomocí tlačítek nahoru(+) a dolů(-) a běží ve smyčce (třetí  7-segmentovka až osmá 7-segmentovka). Vybraná 7-segmentovka bliká.

Středové tlačítko je reset.

## I/O sekce
| Port | Vstup/výstup | Popis funkce |
|:---:|:---:|:---|
| `clk` | Vstup |Hlavní hodinový signál desky |
| `btnc` | Vstup |reset |
| `sw0` | Vstup | Přepínač pro volbu výstupního kmitočtu|
| `btnl` | Vstup | Snížení kmitočtu ve zvoleném řádu |
| `btnr` | Vstup | Zvýšení kmitočtu ve zvoleném řádu |
| `btnu` | Vstup | Zvýšení měněného řádu |
| `btnd` | Vstup | Snížení měněného řádu |
| `ja(1)` | Výstup | Výstupní signál trojúhelníku |
| `ja(2)` | Výstup | Výstupní signál obdélníku |
| `ja(3)` | Výstup | Výstupní signál pily|
| `seg` | Výstup | Active-low výstup pro segmentovku (katoda) |
| `an` | Výstup | Active-lov výstup pro anody segmenovek |

## Top level design
![Image of top level design](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/top_level.jpg)

## Moduly

### Top level
| Název modulu | Popis funkce |
|:-----:|-----|
| `top_level` | Hlavní modul obstarávající spojení mezi zbytkem sub-modulů |

### Debounce
| Název modulu | Popis funkce | Odkaz na výsledky testů |
|:-----:|-----| :---: |
| `Debounce` | Zajišťuje debouncing vstupních tlačítek | Uděláno na cvičeních |
| `clock_enable` | Vysílá pulzy po určitém počtu clocků | Uděláno na cvičeních |

### Freq to phaseShift
| Název modulu | Popis funkce | Odkaz na výsledky testů |
|:-----:|-----| :---: |
| `freq_to_phaseShift` | Z 20-bit čísla znázorňujícího frekvenci přepočítává na použitelnějí `phaseShift` | [Testy](#freq_to_phaseShift) |

### Freq select
| Název modulu | Popis funkce | Odkaz na výsledky testů |
|:-----:|-----| :---: |
| `freq_select` | Pomocí vstupních tlačítek zařizuje změnu frekvence, posílá ji generátorům a displeji |  [Testy](#freq_select) |

### Triangle top
| Název modulu | Popis funkce | Odkaz na výsledky testů |
|:-----:|-----| :---: |
| `triangle_top` | Z příchozího fázového posuvu generuje na výstupu trojúhelníkový signál | [Testy](#triangle_top) |
| `phase_accumulator` | Posouvá pozici fázového akumulátoru o vstupní vektor fázového posunu | [Testy](#phase_accumulator) |
| `triangle_gen` | Podle pozice fázového akumulátoru (32-bit vektor) dá na výstup hodnotu trojúhelníku v dané pozici fázového akumulátoru | [Testy](#triangle_gen) |
| `pwm_gen` | Na vstupu modulu je vektor `duty_in`, který se používá ke generaci střídy na výstupu | [Testy](#pwm_gen) |

### Square top
| Název modulu | Popis funkce | Odkaz na výsledky testů |
|:-----:|-----| :---: |
| `square_top` | Funguje jako counter, který si ze vstupní frekvence a frekvence desky spočítá maximalní počet clocků a v polovině maxima změní hodnotu výstupu | [Testy](#square_top) |

### Sawtooth top
| Název modulu | Popis funkce | Odkaz na výsledky testů |
|:-----:|-----| :---: |
| `sawtooth_top` | Top level pro generátor pily, funkčnost podobná s `triangle_top` | [Testy](#sawtooth_top) |
| `sawtoothGen` | Podle pozice fázového akumulátoru (32-bit vektor) dá na výstup hodnotu pily v dané pozici | [Testy](#sawtoothGen) |
| `sigma_Delta` | Sigma-Delta převodník pro pilový průběh | [Testy](#sigma_Delta) |

### Display controller
| Název modulu | Popis funkce | Odkaz na výsledky testů |
|:-----:|-----| :---: |
| `display_controller` | Zajišťuje funkčnost displeje | [Testy](#display_controller) |
| `clock_enable` | Zajišťuje obnovovací frekvenci displeje | Uděláno na cvičeních |
| `counter_bin` | Čítaním zvyšuje binární číslo, kterým vybírá aktivní anodu | [Testy](#counter_bin) |
| `counter_blink` | Zajišťuje blikání měněné číslice při změně frekvence | [Testy](#counter_blink) |
| `bin2bcd` | Přepočítává binární číslo na BCD kód | Uděláno na cvičeních |
| `bin2seg` | Zobrazuje jednu binární číslici na 7-segmentovém displeji | Uděláno na cvičeních |

<!-- | Název modulu | Popis funkce |
|:-----:|-----|
| `phase_accumulator` | Posouvá pozici fázového akumulátoru o vstupní vektor fázového posunu |
| `pwm_gen` | Na vstupu modulu je vektor `duty_in`, který se používá ke generaci střídy na výstupu |
| `sawtoothGen` | Podle pozice fázového akumulátoru (32-bit vektor) dá na výstup hodnotu pily v dané pozici |
| `sawtoot_top` | Top level pro generátor pily |
| `shiftGen` | Z 20-bit čísla znázorňujícího frekvenci přepočítává na použitelnějí `phaseShift` |
| `sigma_Delta` | Sigma-Delta převodník pro pilový průběh |
| `triangle_top` | Top level generátoru trojúhelníkového průběhu |
| `triangle_gen` | Podobně jako `sawtootGen` dává na výstup hodnotu pily v dané pozici fázového akumulátoru | -->

## Simulace

<!--### Top level -->
<!-- Prosím, ještě dopsat freq_select (chápu že se člověk může přehlédnout) -->

<!-- --- -->

### freq_to_phaseShift

![Image of simulation of shiftGen](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/shiftGen_tb.png)

Tento modul úderem každé log. úrovně H vstupu `update_tick` přepočítává vstupní frekvenci (`freq_in`) v Hz na 32-bit fázový posun pro výstup `phaseShift`

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/shiftGen_tb.vhd)

---

### freq_select

![Image of simulation of freq_select](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/freq_select_tb.png)

<!-- !!!!!!!DOPSAT!!!!!!!!! -->

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/freq_select_tb.vhd)

---

### triangle_top

![Image of simulation of triangle_top](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/triangle_top/tb_top_triangle.png)

Jedná se o top level generátoru trojúhelníkového průběhu. Vstupem jsou clk, rst a phase_step, výstupem pak obdélníkový průběh se střídou, jejíž průměrná hodnota znázorňuje trojúhelníkový průběh

- V simulaci jde vidět vstupní fázový posun `phase_step` a na výstupu `triangle_out` pak výstupní signál s PWM (Pulse-Width Modulation)

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/top_triangle_tb.vhd)

---

### phase_accumulator

![Image of simulation of phase_accumulator](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/sawtooth_top/phase_accumulator_1.png)

Modul přičítá každým taktem hodnotu vstupu na výstup. Tím se zajišťuje fázový posuv.

- Vstupem je 32-bit `phase_step`
- Výstupem je 32-bit `phase_out`

Je vidět že se každým taktem výstup zvětšuje o vstupní hodnotu

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/phase_accumulator_tb.vhd)

---

### triangle_gen

![Image of simulation of triangle_gen](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/triangle_top/tb_triangle_gen_1.png)

Modul generuje na výstupu `triangle` 8-bit číslo znázorňující amplitudu trojúhelníkového signálu v závislosti na poloze 32-bit čísla `phase`znázorňující fázi v daném časovém úseku

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/triangle_gen_tb.vhd)

---

### pwm_gen

![Image of simulation of pwm_gen](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/triangle_top/tb_pwm_gener.png)

Podle vstupní úrovně dává modul na výstup obdélníkový průběh s danou střídou znázorňující požadovanou hodnotu

- Vstupem je 7-bit `duty_in`
- Výstupem je 1-bit obdélník se střídou

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/pwm_gen_tb.vhd)

---

### `square_top`
![image of simulation of square_top](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/square_top/square_top_tb.png)

Modul při `en` 1 vezme frekvenci a přepočítá frekvenci na počet clocků, poté funguje jako `counter` a v polovině maxima překlopí výstupní signál

- V simulaci můžeme pozorovat jak se změní šířka impulzů až poté co se na `en` objeví 1, i přes to že frekvence se změnila už dříve

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/square_gen_tb.vhd)

---

### sawtooth_top

![Image of simulation of sawtooth_top](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/sawtooth_top/sawtooth_top_1.png)

Jedná se o top level generátoru pilového průběhu. Vstupem jsou clk, rst a phase_Shift, výstupem pak obdélníkový průběh se střídou, jejíž průměrná hodnota znázorňuje pilový průběh

- V simulaci jde vidět vstupní fázový posun a na výstupu pak výstupní signál sigma-delta převodníku

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/sawtooth_top_tb.vhd)

---

### sawtoothGen

![Image of simulation of sawtoothGen](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/sawtooth_top/sawtoothGen_1.png)

Modul přepočítává vstupní 32-bit hodnotu fáze na 8-bit hodnotu pily. Spodních 24 bitů je pro 8-bitovou hloubku výstupu zbytečných, tudíž se mohou vyhodit.

- Horní signál `phase` je současnou hodnotou fáze
- Spodní signál `sawtooth` je zobrazen analogově a ukazuje pilový průběh

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/sawtoothGen_tb.vhd)

---

### sigma_Delta

![Image of simulation of sigma_Delta](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/sawtooth_top/sigma_delta_1.png)

Tento modul využívá koncepce sigma-delta převodníku pro konverzi 8-bit digitálního signálu `data_in` na 1-bit výstupní signál `dac_out`, který má ale vyšší frekvenci. "Analogová" hodnota je pak vyjádřena v průměrné hodnotě signálu s pomocí PDM (Pulse Density Modulation)

- V simulaci můžeme pozorovat změnu hustoty pulzů na výstupu `dac_out` se změnou vstupní hodnoty `data_in`

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/sigma_delta_dac_tb.vhd)

---

### display_controller
![image of simulation of display_controller](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/display_controller/display_controller_tb.png)

Modul, který zpracovává veškerá data zobrazovaná na displeji

- V simulaci můžeme vidět jak se postupně mění aktivní anoda a v případě nepoužívaných anod jsou všechny anody nastaveny na 1
- Dále jde vidět jak se na výstup `seg` postupně přiřazují jednotlivé číslice vstupní frekvence

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/display_controller_tb.vhd)

---

<!--### `shiftGen`

![Image of simulation of shiftGen](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/shiftGen_tb.png)

Tento modul úderem každé log. úrovně H vstupu `update_tick` přepočítává vstupní frekvenci (`freq_in`) v Hz na 32-bit fázový posun pro výstup `phaseShift`

--- -->


### counter_bin
![image of simulation of counter_bin](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/display_controller/counter_bin_tb.png)

Při každé náběžné hraně `clock`, pokud je `en` 1, zvýší svoji binární hodnotu o 1 

- V simulaci jde vidět jak čítač dosáhne maximální hodnoty, poté se vynuluje a začne čítat znovu

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/counter_bin_tb.vhd)

---
### counter_blink
![image of simulation of counter_blink](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/display_controller/counter_blink_tb.png)

Tvoří obdelníkové pulzy s pevně danou periodou

[Testbench soubor zde](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/MAIN/waveformGen/waveformGen.srcs/sim_1/new/conter_blink_tb.vhd)

---

## Výstupní filtr
![image of an output](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/filter.png)

---

## Závěr
