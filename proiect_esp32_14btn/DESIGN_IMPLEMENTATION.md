# Implementare schemă/PCB (ghid complet)

Acest document definește schema completă cerută (simboluri + footprint-uri), placement inițial și pași de export.

## Simboluri și footprint-uri concrete
- ESP32: `RF_Module:ESP32-WROOM-32` -> footprint `RF_Module:ESP32-WROOM-32`
- RJ45 x2: `Connector:RJ45_8` -> footprint ex. `Connector_RJ:RJ45_Amphenol_RJHSE538X`
- Rezistențe intrare x14: `Device:R` 220R -> `Resistor_SMD:R_0603_1608Metric`
- Header UART/programare: `Connector:Conn_01x06` -> `Connector_PinHeader_2.54mm:PinHeader_1x06_P2.54mm_Vertical`
- USB-C intrare: simbol din CERN `cerni2c:*USB_C*` (în funcție de disponibil în librărie)
- PD sink: simbol CERN compatibil (sau fallback standard custom)
- Buck 3.3V: `Regulator_Switching:*` (alege modelul final după disponibil footprint)

## Rețea neturi butoane
- J1.1..J1.7 -> BTN1..BTN7 -> Rser -> GPIO13/14/16/17/18/19/21
- J2.1..J2.7 -> BTN8..BTN14 -> Rser -> GPIO22/23/25/26/27/32/33
- J1.8 și J2.8 -> GND

## Alimentare 5-12V prin USB-C
- USB-C VBUS -> F1 (polyfuse) -> TVS -> PD sink + Buck input
- PD sink setează 9V/12V când sursa suportă PD
- Buck ieșire 3.3V -> ESP32 + pullup-uri/logica

## Placement PCB inițial
1. ESP32 central-sus, keepout antenă spre marginea plăcii.
2. RJ45 J1/J2 pe muchia dreaptă/stângă pentru cablare directă.
3. USB-C pe muchia de jos.
4. Etajul de putere (PD + buck + TVS + fuse) compact lângă USB-C.
5. Rezistențele serie BTN aproape de intrarea în MCU.
6. Header UART la margine accesibilă.

## Stare actuală în acest repository
Fișierele `.kicad_sch` și `.kicad_pcb` sunt bootstrap și necesită completare în KiCad GUI.
`kicad-cli` v7 instalat aici permite exporturi, dar nu oferă comandă directă ERC/DRC în această versiune.

## Dependință CERN libs
Clonează local librăriile CERN lângă repo:
`git clone https://gitlab.com/ohwr/cern-kicad-libs.git ../cern-kicad-libs`
