#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCH="$ROOT_DIR/esp32_14btn_mqtt.kicad_sch"
PCB="$ROOT_DIR/esp32_14btn_mqtt.kicad_pcb"
OUT="$ROOT_DIR/exports"

mkdir -p "$OUT/gerbers" "$OUT/drill"

kicad-cli sch export pdf -o "$OUT/schematic.pdf" "$SCH"
kicad-cli sch export python-bom -o "$OUT/bom.xml" "$SCH"
kicad-cli pcb export gerbers -o "$OUT/gerbers" "$PCB"
kicad-cli pcb export drill -o "$OUT/drill/" "$PCB"

echo "Done. Artifacts in $OUT"
