# Proiect KiCad: ESP32 + 14 butoane + MQTT

## Cerință
Placă PCB cu ESP32 care citește 14 pushbutoane externe prin 2 mufe RJ45 (7 semnale + 1 GND pe fiecare mufă) și publică stările prin MQTT.

## Arhitectură hardware propusă
- MCU: `ESP32-WROOM-32E` (modul)
- Conectori butoane:
  - `J1 RJ45` -> BTN1..BTN7 + GND
  - `J2 RJ45` -> BTN8..BTN14 + GND
- Alimentare:
  - Intrare 5V pe conector screw terminal sau USB-C breakout
  - Regulator 3.3V (de ex. AMS1117-3.3 sau MP1584 dacă vrei eficiență mai bună)
- Protecție input:
  - Rezistențe serie 220Ω pe fiecare intrare buton
  - ESD TVS array pe liniile care vin din afara plăcii (opțional, recomandat)
- Boot/flash:
  - Butoane EN și IO0
  - Header UART (3V3, GND, TX0, RX0, EN, IO0)

## Mapare pini recomandată (GPIO)
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

## Alocare RJ45 (exemplu T568B logic intern)
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
