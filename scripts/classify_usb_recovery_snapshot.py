#!/usr/bin/env python3
"""Classify an EXISTING macOS system_profiler SPUSBDataType JSON snapshot.

No USB library, subprocess, network, enumeration, hardware access or vendor
commands. This is a descriptor heuristic, never a YDXJ2 compatibility verdict.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re


def usb_id(value):
    if not isinstance(value, str):
        return None
    m = re.match(r'^0x([0-9a-fA-F]{1,4})(?:\s|$)', value)
    return int(m[1], 16) if m else None


def classify(snapshot):
    if not isinstance(snapshot, dict) or not isinstance(snapshot.get('SPUSBDataType'), list):
        raise ValueError('expected saved system_profiler SPUSBDataType JSON')
    found = []

    def walk(nodes):
        for node in nodes:
            if not isinstance(node, dict):
                continue
            vid, pid = usb_id(node.get('vendor_id')), usb_id(node.get('product_id'))
            if vid == 0x4255:
                mfr, product = node.get('manufacturer'), node.get('_name')
                mode = 'unknown'
                if mfr == 'Amba':
                    mode = 'FORCEUSB descriptor heuristic'
                elif product == 'Ambarella USB generic class':
                    mode = {'AMBA': 'AMBOOT descriptor heuristic',
                            'Ambarella': 'UST descriptor heuristic'}.get(mfr, 'unknown')
                found.append(dict(vid='0x4255', pid=None if pid is None else f'0x{pid:04x}',
                                  manufacturer=mfr, product=product,
                                  location_id=node.get('location_id'), mode=mode,
                                  s2e_pid_matches_public_table=pid == 0x000c,
                                  ydxj2_compatibility_proven=False,
                                  pre_rtos_entry_proven=False))
            children = node.get('_items', [])
            if isinstance(children, list):
                walk(children)
    walk(snapshot['SPUSBDataType'])
    return dict(scope='saved descriptor snapshot only; no device contact',
                candidates=found,
                absence_means='No 0x4255 node in this snapshot; USB boot capability is not disproved.',
                next_step='Preserve raw snapshot and capture conditions; do not infer board, DRAM profile, SRAM map or firmware compatibility.')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('snapshot', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    raw = args.snapshot.read_bytes()
    result = classify(json.loads(raw))
    result['input'] = str(args.snapshot)
    result['input_sha256'] = hashlib.sha256(raw).hexdigest()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + '\n')
    print(json.dumps(dict(candidates=len(result['candidates']), output=str(args.output))))


if __name__ == '__main__':
    main()
