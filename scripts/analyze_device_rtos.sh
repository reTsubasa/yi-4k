#!/usr/bin/env bash
# Offline reconstruction of the captured, hash-pinned 1.10.7 device image.
set -euo pipefail
task_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$task_root"
: "${GHIDRA_DIR:?Set GHIDRA_DIR to an existing Ghidra 12.2 installation}"
.venv-reverse/bin/python scripts/device_rtos_compare.py
task_out=artifacts/device/2026-11-09-linux/rtos-analysis
mkdir -p "$task_out/ghidra-project"
if [[ ! -f "$task_out/ghidra-project/yi4k_device_1107.gpr" ]]; then
    "$GHIDRA_DIR/support/analyzeHeadless" "$task_out/ghidra-project" yi4k_device_1107 \
      -import "$task_out/rtos-window.bin" -loader BinaryLoader -processor ARM:LE:32:v7 \
      -cspec default -loader-baseAddr 0xA0100000 -scriptPath scripts/ghidra \
      -preScript Yi4kDeviceBss.java -preScript Yi4kPrepare.java "$task_out/same-body-seeds.tsv" \
      -postScript Yi4kExport.java "$task_out/full" -analysisTimeoutPerFile 900 -max-cpu 4 \
      -log "$task_out/ghidra-analysis.log" -scriptlog "$task_out/ghidra-script.log"
fi
"$GHIDRA_DIR/support/analyzeHeadless" "$task_out/ghidra-project" yi4k_device_1107 \
  -process rtos-window.bin -noanalysis -scriptPath scripts/ghidra \
  -preScript Yi4kPrepare.java "$task_out/focus-seeds.tsv" \
  -postScript Yi4kFocusedExport.java "$task_out/focused" "$task_out/focus-seeds.tsv" \
  -max-cpu 4 -log "$task_out/ghidra-focused.log" -scriptlog "$task_out/ghidra-focused-script.log"
