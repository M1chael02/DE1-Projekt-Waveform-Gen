# DE1-Projekt-Waveform-Gen
Jednoduchý generátor průběhů signálu s využitím vývojové desky Nexys A7-50T ve VHDL
## Členové týmu
- Michael Jurča (M1chael02) - pilový průběh, správa repozitáře
- Denis Kaňovský (profesorPrymula) - trojúhelníkový průběh, dokumentace
- Dominik Nádvorník (nadvornikdominik) - obdélníkový průběh, top level design

## Obsah
- Základní popis fungování
- Top level design
- Moduly
- Simulace
- Závěr

## Základní popis fungování
Funkční generátor je druh generátoru, který umí na výstupu generovat různé tvary signálů. Náš projekt se bude zabývat třemi průběhy, a to obdélníkovým, trojúhelníkovým a harmonickým.

Celý projekt využívá 7-segmentovku k zobrazení nastaveného kmitočtu výstupu. Následně využívá tří výstupních pinů pro tři průběhy. Také se počítá s pěti tlačítky pro obsluhu přístroje.

Každý z tvarů má vlastní výstup, a to z důvodu potřeby různých rekonstrukčních filtrů pro každý z tvarů.

Frekvence je indikováná pomocí třetí až osmé 7-segmentovky přímo v Hz. Nejvyšší možné rozlišení je 1Hz. 

Frekvence výstupního signálu se volí pomocí tlačítek vpravo(+) a vlevo(-), řád se mění pomocí tlačítek nahoru(+) a dolů(-) a běží ve smyčce (třetí  7-segmentovka až osmá 7-segmentovka). Vybraná 7-segmentovka bliká.

Středové tlačítko je reset.

## Top level design
![Image of top level design](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/top_level.jpg)

## Moduly
| Název modulu | Popis funkce |
|-----|-----|
| `phase_accumulator` | Posouvá pozici fázového akumulátoru o vstupní vektor fázového posunu |
| `pwm_gen` | Na vstupu modulu je vektor `duty_in`, který se používá ke generaci střídy |
| `sawtoothGen` | Podle pozice fázového akumulátoru (32-bit vektor) dá na výstup hodnotu pily v dané pozici |
| `sawtoot_top` | Top level pro generátor pily |
| `shiftGen` | Z 20-bit čísla znázorňujícího frekvenci přepočítává na použitelnějí `phaseShift` |
| `sigma_Delta` | Sigma-Delta převodník pro pilový průběh |
| `triangle_top` | Top level generátoru trojúhelníkového průběhu |
| `triangle_gen` | Podobně jako `sawtootGen` dává na výstup hodnotu pily v dané pozici fázového akumulátoru |

## Simulace

### `phase_accumulator` 

![Image of simulation of phase_accumulator](https://github.com/M1chael02/DE1-Projekt-Waveform-Gen/blob/main/images/Simulations/sawtooth_top/phase_accumulator_1.png)

Modul přičítá každým taktem hodnotu vstupu na výstup. Tím se zajišťuje fázový posuv.

- Vstupem je 32-bit `phase_step`
- Výstupem je 32-bit `phase_out`

Je vidět že se každým taktem výstup zvětšuje o vstupní hodnotu
---

### `pwm_gen`

![Image of simulation of pwm_gen]()

Podle vstupní úrovně dává modul na výstup obdélníkový průběh s danou střídou znázorňující požadovanou hodnotu

- Vstupem je 7-bit `duty_in`
- Výstupem je 1-bit obdélník se střídou

---

### `sawtoothGen`

![Image of simulation of pwm_gen]()

Modul přepočítává vstupní 32-bit hodnotu fáze na 8-bit hodnotu pily. Spodních 24 bitů je pro 8-bitovou hloubku výstupu zbytečných, tudíž se mohou vyhodit.

- Horní signál `phase` je současnou hodnotou fáze
- Spodní signál `sawtooth` je zobrazen analogově a ukazuje pilový průběh

---

### `sawtoot_top`

---

### `shifGen`

---

### `sigma_Delta`

---

### `triangle_top`

---

### `triangle_gen`

---