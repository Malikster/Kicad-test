# Proiect KiCad: ESP32 + 14 butoane + MQTT

## Cerință
Placă PCB cu ESP32 care citește 14 pushbutoane externe prin 2 mufe RJ45 (7 semnale + 1 GND pe fiecare mufă) și publică stările prin MQTT.

## Update cerințe (revizie)
1. Alimentare obligatorie prin USB-C, cu suport **5V până la 12V** la intrare.
2. Clarificare arhitectură I/O: dacă ESP32 citește direct cele 14 intrări sau e nevoie de componentă intermediară.

## Arhitectură hardware propusă
- MCU: `ESP32-WROOM-32E` (modul)
- Conectori butoane:
  - `J1 RJ45` -> BTN1..BTN7 + GND
  - `J2 RJ45` -> BTN8..BTN14 + GND
- Alimentare USB-C (5V-12V):
  - `J3 USB-C receptacle` configurat ca **power sink**
  - `U_PD`: controller USB-C PD sink (ex: CH224K / IP2721 / STUSB4500)
  - `U_BUCK`: convertor buck 5V-12V -> 3.3V (ex: MP1584EN / AP63203)
  - protecții recomandate:
    - `F1` polyfuse pe VBUS
    - `D_TVS` TVS pe VBUS
    - protecție inversare / hot-plug (ideal eFuse)
- Protecție input butoane:
  - Rezistențe serie 220Ω pe fiecare intrare BTN
  - ESD TVS array pe liniile care vin prin RJ45 (recomandat)
- Boot/flash:
  - Butoane EN și IO0
  - Header UART (3V3, GND, TX0, RX0, EN, IO0)

## Notă importantă USB-C (5V-12V)
Dacă placa NU include controller PD, majoritatea surselor USB-C vor da implicit doar **5V**.
Pentru 9V/12V real pe USB-C, proiectul trebuie să includă explicit negocierea PD (U_PD).

## ESP32 și cele 14 intrări: direct sau intermediar?
**Da, ESP32 poate citi direct toate cele 14 butoane**, fără multiplexor/expander, dacă:
- folosești GPIO-uri disponibile și stabile la boot;
- configurezi pinii ca `INPUT_PULLUP`;
- butoanele închid la GND (active-low).

### Când merită componentă intermediară
Folosești expander I2C/SPI doar dacă vrei:
- mai puține trasee directe până la ESP32,
- filtrare hardware suplimentară,
- scalare viitoare (>14 butoane),
- izolare mai bună la zgomot pe cabluri lungi.

Exemple expandere:
- `MCP23017` (I2C, 16 GPIO)
- `PCF8575` (I2C, 16 GPIO)

## Mapare pini recomandată (GPIO directe)
> Evit pinii sensibili de boot unde e posibil.

- BTN1  -> GPIO13
- BTN2  -> GPIO14
- BTN3  -> GPIO16
- BTN4  -> GPIO17
- BTN5  -> GPIO18
- BTN6  -> GPIO19
- BTN7  -> GPIO21
- BTN8  -> GPIO22
- BTN9  -> GPIO23
- BTN10 -> GPIO25
- BTN11 -> GPIO26
- BTN12 -> GPIO27
- BTN13 -> GPIO32
- BTN14 -> GPIO33

Config software recomandat:
- `INPUT_PULLUP` pe toate intrările
- Butonul închide la GND (active-low)
- Debounce software 20-40 ms

## Alocare RJ45 (intern pe placă)
### J1
1. BTN1
2. BTN2
3. BTN3
4. BTN4
5. BTN5
6. BTN6
7. BTN7
8. GND

### J2
1. BTN8
2. BTN9
3. BTN10
4. BTN11
5. BTN12
6. BTN13
7. BTN14
8. GND

## MQTT (propunere topic-uri)
- Topic bază: `panou/butoane`
- Publicare stări aggregate: `panou/butoane/state` (JSON)
- Publicare per buton: `panou/butoane/btnX`

Exemplu payload JSON:
```json
{
  "btn1": 0,
  "btn2": 1,
  "btn3": 0,
  "btn4": 0,
  "btn5": 1,
  "btn6": 0,
  "btn7": 0,
  "btn8": 0,
  "btn9": 1,
  "btn10": 0,
  "btn11": 0,
  "btn12": 0,
  "btn13": 1,
  "btn14": 0
}
```

## Fișiere de proiect
În acest repo am adăugat scheletul proiectului:
- `esp32_14btn_mqtt.kicad_pro`
- `esp32_14btn_mqtt.kicad_sch`
- `esp32_14btn_mqtt.kicad_pcb`

Aceste fișiere sunt punctul de pornire. Schematic-ul și layout-ul trebuie completate în UI-ul KiCad (plasare simboluri, conexiuni, ERC/DRC, rutare).


## Pipeline script (varianta 2)
Poți regenera artefactele automat cu:
```bash
./generate_outputs.sh
```
Scriptul exportă:
- PDF schematic
- BOM XML
- Gerber files
- Drill file

Notă: în KiCad CLI 7.0.11 nu există comandă ERC/DRC directă disponibilă în acest mediu.


## Validare proiect
Rulează verificările rapide cu:
```bash
./validate_project.sh
```
Verifică existența fișierelor de proiect și a exporturilor generate, plus disponibilitatea ERC/DRC în build-ul local de `kicad-cli`.
