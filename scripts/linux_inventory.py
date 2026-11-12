#!/usr/bin/env python3
"""Inventory an extracted YI Linux tree without executing target files.

Requires pyelftools==0.32. Never follows symlinks in the target tree.
"""
import argparse
from collections import Counter
import hashlib
import io
import json
import os
from pathlib import Path
import re
import stat
import zlib

from elftools.elf.elffile import ELFFile


def elf_info(data):
    elf = ELFFile(io.BytesIO(data))
    result = {
        'class': elf.elfclass, 'little_endian': elf.little_endian,
        'type': elf['e_type'], 'machine': elf['e_machine'],
        'entry': hex(elf['e_entry']), 'flags': hex(elf['e_flags']),
        'interpreter': None, 'needed': [], 'soname': None,
        'imports': [], 'exports': [], 'module_info': [],
    }
    for segment in elf.iter_segments():
        if segment['p_type'] == 'PT_INTERP':
            result['interpreter'] = segment.get_interp_name()
    for section in elf.iter_sections():
        if section['sh_type'] == 'SHT_DYNAMIC':
            for tag in section.iter_tags():
                if tag.entry.d_tag == 'DT_NEEDED':
                    result['needed'].append(tag.needed)
                elif tag.entry.d_tag == 'DT_SONAME':
                    result['soname'] = tag.soname
        if section.name == '.dynsym':
            for symbol in section.iter_symbols():
                if not symbol.name:
                    continue
                record = {'name': symbol.name, 'value': hex(symbol['st_value']),
                          'size': symbol['st_size'],
                          'type': symbol['st_info']['type'],
                          'bind': symbol['st_info']['bind']}
                key = 'imports' if symbol['st_shndx'] == 'SHN_UNDEF' else 'exports'
                result[key].append(record)
        if section.name == '.modinfo':
            result['module_info'] = [s.decode('utf-8', 'replace')
                                     for s in section.data().split(b'\0') if s]
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--rootfs', type=Path,
                        default=Path('artifacts/linux-analysis/rootfs'))
    parser.add_argument('--output', type=Path,
                        default=Path('artifacts/linux-analysis'))
    parser.add_argument('--kernel', type=Path,
                        default=Path('artifacts/firmware/v1.10.52/_part_lnx.a9s'))
    parser.add_argument('--baseline-tree', type=Path,
                        help='Saved GitHub recursive tree JSON for the original-import commit')
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=True)
    files, elfs, counts, sizes = [], {}, Counter(), Counter()
    for parent, dirs, names in os.walk(args.rootfs, followlinks=False):
        for name in sorted(dirs + names):
            path = Path(parent) / name
            info = path.lstat()
            record = {'path': '/' + path.relative_to(args.rootfs).as_posix(),
                      'mode': oct(stat.S_IMODE(info.st_mode))}
            if stat.S_ISLNK(info.st_mode):
                record.update(type='symlink', target=os.readlink(path))
            elif stat.S_ISDIR(info.st_mode):
                record['type'] = 'directory'
            elif stat.S_ISREG(info.st_mode):
                data = path.read_bytes()
                record.update(type='file', bytes=len(data),
                              sha256=hashlib.sha256(data).hexdigest())
                sizes[record['path'].split('/')[1]] += len(data)
                if data.startswith(b'\x7fELF'):
                    record['format'] = 'ELF'
                    elfs[record['path']] = elf_info(data)
                elif data.startswith(b'#!'):
                    record['format'] = 'script'
                    record['shebang'] = data.split(b'\n', 1)[0].decode('utf-8', 'replace')
            else:
                record['type'] = 'special'
            counts[record['type']] += 1
            files.append(record)
    dump = lambda name, obj: (args.output / name).write_text(
        json.dumps(obj, ensure_ascii=False, indent=2) + '\n')
    dump('filesystem-inventory.json', sorted(files, key=lambda item: item['path']))
    dump('elf-inventory.json', dict(sorted(elfs.items())))
    if args.baseline_tree:
        tree = json.loads(args.baseline_tree.read_text())
        assert not tree.get('truncated'), 'Incomplete baseline tree'
        original = {'/' + item['path'][len('1.10.9/'):]: item for item in tree['tree']
                    if item['path'].startswith('1.10.9/') and item['type'] == 'blob'}
        compared, seen = [], set()
        for item in files:
            if item['type'] not in ('file', 'symlink'):
                continue
            path = item['path']
            data = (item['target'].encode() if item['type'] == 'symlink'
                    else (args.rootfs / path.lstrip('/')).read_bytes())
            digest = hashlib.sha1(b'blob ' + str(len(data)).encode() + b'\0' + data).hexdigest()
            old = original.get(path)
            status = ('same_content' if old and old['sha'] == digest else
                      'changed_content' if old else 'added_vs_import')
            compared.append({'path': path, 'type': item['type'], 'status': status,
                             'sample_git_blob': digest,
                             'import_git_blob': old['sha'] if old else None})
            seen.add(path)
        for path, old in original.items():
            if path not in seen:
                compared.append({'path': path, 'status': 'not_extracted_or_removed',
                                 'import_git_blob': old['sha']})
        dump('baseline-comparison.json', {
            'scope': 'Content comparison to repository commit described as original 1.10.9 import; not independently authenticated vendor firmware. Device nodes, ownership and mode are not compared.',
            'baseline_commit': '7a5e134d8078f5ca0fad40539cd3954ff290d7f1',
            'baseline_tree': str(args.baseline_tree),
            'counts': dict(Counter(item['status'] for item in compared)),
            'files': sorted(compared, key=lambda item: item['path']),
        })
    kernel = args.kernel.read_bytes()
    start = kernel.index(b'IKCFG_ST') + 8
    decoder = zlib.decompressobj(31)
    config = decoder.decompress(kernel[start:]) + decoder.flush()
    assert config.startswith(b'#') and b'CONFIG_ARM=y' in config
    (args.output / 'kernel.config').write_bytes(config)
    versions = [s.decode('utf-8', 'replace') for s in
                re.findall(rb'Linux version[^\x00\n]+', kernel)]
    summary = {
        'rootfs': str(args.rootfs), 'scope': 'Extracted files; no target execution',
        'counts': dict(counts), 'regular_file_bytes': sum(sizes.values()),
        'bytes_by_top_directory': dict(sizes), 'elf_files': len(elfs),
        'elf_machines': dict(Counter(e['machine'] for e in elfs.values())),
        'elf_types': dict(Counter(e['type'] for e in elfs.values())),
        'kernel_path': str(args.kernel), 'kernel_sha256': hashlib.sha256(kernel).hexdigest(),
        'kernel_versions': versions, 'ikconfig_gzip_offset': hex(start),
        'ikconfig_sha256': hashlib.sha256(config).hexdigest(),
        'extraction_limitations': ['dev/console and dev/null device nodes were not created on host; see extract.log',
                                   'Host ownership is not firmware ownership; consult unsquashfs listing',
                                   'No symlinks were followed when reading files'],
    }
    dump('summary.json', summary)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
