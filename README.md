# DE1-Projekt-Waveform-Gen
Jednoduchý generátor průběhů signálu s využitím vývojové desky Nexys A7-50T ve VHDL
## Členové týmu
- Michael Jurča (M1chael02) - sinusový průběh, správa repozitáře
- Denis Kaňovský (profesorPrymula) - trojúhelníkový průběh, dokumentace
- Dominik Nádvorník (nadvornikdominik) - obdélníkový průběh, top level design

## Obsah
- Abstrakt
- Hardware
- Software
- Praktická ukázka
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