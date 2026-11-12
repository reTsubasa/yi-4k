#!/usr/bin/env bash
# Reproduce the static project using an existing Ghidra installation.
# Does not execute or modify the target firmware.
set -euo pipefail
task_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$task_root"
: "${GHIDRA_DIR:?Set GHIDRA_DIR to an existing Ghidra 12.2 installation}"
if [[ ! -x "$GHIDRA_DIR/support/analyzeHeadless" ]]; then
    echo "Missing analyzeHeadless under GHIDRA_DIR" >&2
    exit 1
fi
target=artifacts/firmware/v1.10.52/_part_lrtos.a9s
python3 - "$target" <<'PY'
import hashlib,sys
p=sys.argv[1]
expected='c1cde4bcd290bdfac9f48ad5eb04f20bc3d208dd1e041ac1376b255dcf846141'
actual=hashlib.sha256(open(p,'rb').read()).hexdigest()
if actual != expected: raise SystemExit('RTOS hash mismatch; stop before applying fixed addresses')
PY
.venv-reverse/bin/python scripts/rtos_tables.py
.venv-reverse/bin/python scripts/rtos_core.py
.venv-reverse/bin/python scripts/rtos_image_ipc.py
mkdir -p artifacts/rtos-reverse/ghidra-project
"$GHIDRA_DIR/support/analyzeHeadless" artifacts/rtos-reverse/ghidra-project yi4k \
  -import "$target" -overwrite -loader BinaryLoader -processor ARM:LE:32:v7 \
  -cspec default -loader-baseAddr 0xA0100000 -scriptPath scripts/ghidra \
  -preScript Yi4kPrepare.java artifacts/rtos-reverse/seeds.tsv \
    artifacts/rtos-reverse/tables/seeds.tsv artifacts/rtos-reverse/core/seeds.tsv \
  -postScript Yi4kExport.java artifacts/rtos-reverse/full \
  -analysisTimeoutPerFile 900 -max-cpu 4 \
  -log artifacts/rtos-reverse/ghidra-analysis.log \
  -scriptlog artifacts/rtos-reverse/ghidra-script.log
"$GHIDRA_DIR/support/analyzeHeadless" artifacts/rtos-reverse/ghidra-project yi4k \
  -process _part_lrtos.a9s -noanalysis -scriptPath scripts/ghidra \
  -postScript Yi4kRefine.java artifacts/rtos-reverse/full \
  -max-cpu 4 -log artifacts/rtos-reverse/ghidra-refinement.log \
  -scriptlog artifacts/rtos-reverse/ghidra-refinement-script.log
