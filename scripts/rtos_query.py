#!/usr/bin/env python3
"""Search the retained static RTOS analysis without an interactive disassembler."""
import argparse
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "artifacts/rtos-reverse"


def main():
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("mode", choices=("function", "strings", "callers", "callees", "xrefs", "asm"))
    p.add_argument("query")
    p.add_argument("--limit", type=int, default=25)
    args = p.parse_args()
    if args.mode == "strings":
        rows = json.loads((OUT / "all-strings.json").read_text())
        hits = [r for r in rows if args.query.casefold() in r["text"].casefold()]
        print(json.dumps({"matches": len(hits), "shown": hits[:args.limit]}, indent=2, ensure_ascii=False))
        return
    rows = json.loads((OUT / "full/functions.json").read_text())
    if args.mode == "function":
        try:
            address = int(args.query, 16) & ~1
        except ValueError:
            address = None
        def matches(row):
            if address is None:
                return args.query.casefold() in row["name"].casefold()
            return any(int(lo, 16) <= address <= int(hi, 16)
                       for lo, hi in (s.split("-") for s in row["body_ranges"]))
        hits = [r for r in rows if matches(r)]
        for row in hits[:args.limit]:
            if "decompiled_file" in row:
                row["local_file"] = str(OUT / "full" / row["decompiled_file"])
        print(json.dumps({"matches": len(hits), "shown": hits[:args.limit]}, indent=2))
        return
    address = int(args.query, 16) & ~1
    if args.mode == "asm":
        found = 0
        with (OUT / "full/listing.asm").open() as f:
            for line in f:
                at = int(line.split()[0], 16)
                if at >= address:
                    print(line.rstrip())
                    found += 1
                    if found >= args.limit:
                        break
        return
    filename = "references.tsv" if args.mode == "xrefs" else "calls.tsv"
    names = {int(r["entry"], 16): r["name"] for r in rows}
    found = 0
    non_memory_targets = 0
    with (OUT / "full" / filename).open() as f:
        next(f)
        for line in f:
            parts = line.rstrip().split("\t")
            if args.mode == "xrefs":
                # Ghidra also exports Stack/Register address-space references.
                # They cannot refer to the requested numeric memory address.
                try:
                    target = int(parts[1], 16)
                except ValueError:
                    non_memory_targets += 1
                    continue
                hit = (target & ~1) == address
            else:
                col = 2 if args.mode == "callers" else 0
                hit = (int(parts[col], 16) & ~1) == address
                # calls.tsv also retains intra-function branches for CFG work.
                # Hide these in a function-level callees query.
                if args.mode == "callees" and "CALL" not in parts[3]:
                    target = int(parts[2], 16) & ~1
                    hit = hit and target in names and target != address
            if hit:
                extra = names.get(int(parts[0], 16), "")
                print(line.rstrip(), extra, sep="\t")
                found += 1
                if found >= args.limit:
                    break
    print(f"shown={found}; bounded to --limit; indirect targets may be unresolved")
    if non_memory_targets:
        print(f"non-memory targets skipped={non_memory_targets}")


if __name__ == "__main__":
    main()
