#!/usr/bin/env python3
"""Export bounded static evidence for the device 1.10.7 native voice path.
No camera connection or target execution. Requires the reverse venv's capstone.
"""
import argparse
import hashlib
import json
import struct
from pathlib import Path
from capstone import Cs, CS_ARCH_ARM, CS_MODE_ARM

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
EXPECTED = 'eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c'

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / 'artifacts/device/2026-11-10-native-voice/static-evidence.json')
    args = parser.parse_args()
    binary = ROOT / 'artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin'
    data = binary.read_bytes()
    digest = hashlib.sha256(data).hexdigest()
    if digest != EXPECTED:
        raise SystemExit(f'Unexpected image SHA256: {digest}')
    md = Cs(CS_ARCH_ARM, CS_MODE_ARM)
    def instructions(lo, hi):
        return [dict(address=f'0x{x.address:08x}', mnemonic=x.mnemonic, operands=x.op_str)
                for x in md.disasm(data[lo-BASE:hi-BASE], lo)]
    def word(address):
        return struct.unpack_from('<I', data, address-BASE)[0]
    def cstring(address):
        return data[address-BASE:].split(b'\0', 1)[0].decode('ascii')
    got = 0xA04CACE8 + word(0xA04CAE80)
    phrase_string_search = {}
    for phrase in ('开始录像', 'start recording', 'begin recording'):
        utf8 = phrase.encode('utf-8')
        phrase_string_search[phrase] = {
            'utf8_offset': data.find(utf8),
            'utf16le_offset': data.find(phrase.encode('utf-16le')),
        }
    offsets = {
        'en': [0x278, 0x264, 0x94, 0x114, 0xA4, 0x190, 0x60, 0x258],
        'zh': [0x1BC, 0x9C, 0x224, 0x108, 0x1CC, 0x1B8, 0x1DC, 0x1C],
    }
    task_snapshots = []
    task_root = ROOT / 'artifacts/device/2026-11-10-rtos-console-route/collect-after-reboot-03'
    expected_header = 'ID PRI PREEMPT SCHED STAT NEXT_ID STKSIZE STKPEAK STKUSED STKBASE STKEND STKPTR SMP_CORE NAME'
    for task_path in sorted(task_root.glob('*tsk*.txt')):
        task_bytes = task_path.read_bytes()
        lines = task_bytes.decode('utf-8').splitlines()
        header = ' '.join(lines[0].split())
        if header != expected_header:
            raise SystemExit(f'Unexpected task table header: {task_path}')
        rows = [line.strip() for line in lines if line.rstrip().endswith('VoiceCmd_Task')]
        if len(rows) != 1:
            raise SystemExit(f'Expected one VoiceCmd_Task row in {task_path}')
        columns = rows[0].split()
        task_snapshots.append(dict(path=str(task_path.relative_to(ROOT)),
            sha256=hashlib.sha256(task_bytes).hexdigest(), header=header, raw_row=rows[0],
            id=int(columns[0]), priority=int(columns[1]), preempt=int(columns[2]),
            schedule_count=int(columns[3]), state=columns[4],
            stack_bytes=int(columns[6]), stack_base=columns[9], stack_end=columns[10],
            stack_pointer=columns[11], core=columns[12], name=columns[13]))
    report = dict(
        evidence_type='static; saved device window, existing Ghidra pseudocode, Capstone ARM disassembly',
        image=str(binary.relative_to(ROOT)), image_sha256=digest, base=f'0x{BASE:08x}',
        runtime_validation='Existing native task table snapshots only; no audio/recognition validation',
        existing_runtime_task_snapshots=task_snapshots,
        strings={f'0x{a:08x}': cstring(a) for a in [
            0xA056A954, 0xA059A8B0, 0xA056A98C, 0xA0564038,
            0xA056406C, 0xA056422C, 0xA056D3D8, 0xA0643F80]},
        pcm_command_names=[cstring(word(0xA056E2C8+4*i)) for i in range(5)],
        pcm_language_suffixes=[cstring(word(0xA056E3F4+4*i)) for i in range(2)],
        phrase_string_search=phrase_string_search,
        model_got=f'0x{got:08x}',
        model_references={lang: [dict(got_offset=f'0x{o:x}', pointer=f'0x{word(got+o):08x}',
                                prefix_16_bytes=data[word(got+o)-BASE:word(got+o)-BASE+16].hex())
                               for o in os] for lang, os in offsets.items()},
        instruction_ranges={name: instructions(lo, hi) for name, lo, hi in [
            ('language_shell_selector', 0xA01ABEC0, 0xA01ABF60),
            ('voice_test_shell_setting', 0xA01ABD80, 0xA01ABE14),
            ('session_voice_field_is_sampling_flag', 0xA0195CBC, 0xA0195CD0),
            ('sampling_start', 0xA01358C8, 0xA0135964),
            ('ui_language_to_voice_selector', 0xA01C779C, 0xA01C77C0),
            ('voice_init_config', 0xA01B295C, 0xA01B29BC),
            ('voice_record_button_dispatch', 0xA019DCA8, 0xA019DCD0),
            ('voice_record_button_gate', 0xA019F66C, 0xA019F6C4),
            ('voice_to_app_record_event', 0xA01A0958, 0xA01A098C),
        ]},
        limitations=[
            'Model byte format and exact recognized Mandarin phrases are not decoded.',
            'Compiled code is not proof that the product exposes or enables voice control.',
            'Existing native ps tsk snapshots show a waiting task; no new live microphone, language change, voice setting write or recording was performed.',
            'The Ghidra output has inferred signatures; ARM return values must be checked before reuse.',
        ],
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n')
    print(args.output)

if __name__ == '__main__':
    main()
