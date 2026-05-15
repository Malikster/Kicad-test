#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SCH="$ROOT_DIR/esp32_14btn_mqtt.kicad_sch"
PCB="$ROOT_DIR/esp32_14btn_mqtt.kicad_pcb"
OUT="$ROOT_DIR/exports"

fail() { echo "[FAIL] $*"; exit 1; }
pass() { echo "[OK]   $*"; }

command -v kicad-cli >/dev/null 2>&1 || fail "kicad-cli not found"
KVER="$(kicad-cli version | tr -d '\n')"
pass "kicad-cli detected: $KVER"

[[ -f "$SCH" ]] || fail "Missing schematic: $SCH"
[[ -f "$PCB" ]] || fail "Missing PCB: $PCB"
pass "Project files exist"

[[ -f "$OUT/schematic.pdf" ]] || fail "Missing export: schematic.pdf"
[[ -f "$OUT/bom.xml" ]] || fail "Missing export: bom.xml"
[[ -f "$OUT/drill/esp32_14btn_mqtt.drl" ]] || fail "Missing drill file"
[[ -d "$OUT/gerbers" ]] || fail "Missing gerbers folder"

GERBER_COUNT="$(find "$OUT/gerbers" -maxdepth 1 -type f | wc -l)"
[[ "$GERBER_COUNT" -ge 10 ]] || fail "Too few gerber outputs: $GERBER_COUNT"
pass "Exports found (gerbers: $GERBER_COUNT files)"

if kicad-cli sch --help | grep -q '\berc\b'; then
  pass "ERC subcommand available in this KiCad CLI build"
else
  echo "[WARN] ERC subcommand not available in this KiCad CLI build"
fi

if kicad-cli pcb --help | grep -q '\bdrc\b'; then
  pass "DRC subcommand available in this KiCad CLI build"
else
  echo "[WARN] DRC subcommand not available in this KiCad CLI build"
fi

pass "Validation completed"
