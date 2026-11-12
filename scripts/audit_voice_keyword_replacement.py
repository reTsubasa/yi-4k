#!/usr/bin/env python3
"""Offline model-envelope preflight; no acoustic recognizer or device writes.

The reversible resource transform is not authentication. Host format validity
does not attest that the vendor parser, loader, or recognizer accepts a model.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BASE = 0xA0100000
IMAGE_SHA = "eee44c6c530183ece1e3872cb3e8958919a9aa418953899dbea8b9889987381c"
RESOURCE_ROOT = ROOT / "artifacts/device/2026-11-10-voice-gui-resources"
SEED = 0x3FBB720F


def sha(data):
    return hashlib.sha256(data).hexdigest()


def require(ok, reason):
    if not ok:
        raise ValueError(reason)


def transform(data, *, encode=False):
    """Encode/decode in memory, with the known stock recurrence and seed."""
    seed, output = SEED, bytearray()
    for off in range(0, len(data), 4):
        part = data[off:off + 4]
        word = int.from_bytes(part, "little")
        decoded = word if encode else word ^ seed
        output.extend((word ^ seed).to_bytes(4, "little")[:len(part)])
        seed = (decoded - seed) & 0xFFFFFFFF
    return bytes(output)


def parse_weights(data):
    """Strict host envelope checks for this observed float32 container family."""
    require(4 <= len(data) <= 16 * 1024 * 1024, "invalid container size")
    cursor = 0

    def take(n):
        nonlocal cursor
        require(0 <= n <= len(data) - cursor, "truncated container")
        value = data[cursor:cursor + n]
        cursor += n
        return value

    def u32():
        return struct.unpack("<I", take(4))[0]

    count, tensors, names = u32(), [], set()
    require(1 <= count <= 1024, "invalid tensor count")
    for _ in range(count):
        match = re.match(rb"([A-Za-z0-9_]+):(weight|bias|gamma|beta|mean|variance):", data[cursor:cursor + 160])
        require(match is not None, "invalid tensor name")
        name = take(match.end()).decode("ascii")
        require(name not in names, "duplicate tensor name")
        names.add(name)
        rank = u32()
        require(1 <= rank <= 4, "invalid tensor rank")
        shape = [u32() for _ in range(rank)]
        require(all(1 <= dim <= 1_048_576 for dim in shape), "invalid tensor dimension")
        length = math.prod(shape) * 4
        offset = cursor
        payload = take(length)
        require(all(math.isfinite(v[0]) for v in struct.iter_unpack("<f", payload)), "nonfinite tensor value")
        tensors.append({"name": name, "shape": shape, "offset": offset, "bytes": length,
                        "sha256": sha(payload)})
    require(take(8) == b"version:", "missing version marker")
    version_length = u32()
    require(0 < version_length <= 256, "invalid version length")
    raw = take(version_length)
    require(all(32 <= b < 127 for b in raw), "invalid version text")
    require(cursor == len(data), "trailing container bytes")
    return {"tensors": tensors, "version": raw.decode("ascii"), "tensor_count": count,
            "float32_count": sum(t["bytes"] // 4 for t in tensors)}


def model_shape_check(graph, weights, stage):
    lines = [line.strip() for line in graph.decode("ascii").splitlines()
             if line.strip() and not line.startswith("#")]
    require(lines[0] == ("AudioNIN,100,1,13" if stage == 1 else "AudioNIN,198,1,13"), "graph input declaration mismatch")
    layer_names = {line.split(",")[0] for line in lines}
    require(all(t["name"].split(":")[0] in layer_names for t in weights["tensors"]), "tensor does not name a graph layer")
    shapes = {t["name"]: t["shape"] for t in weights["tensors"]}
    if stage == 2:
        require("final_layer_fcF32,fully_connected,10,FLOAT32,YES,embdd_layer_fcF32" in lines, "classifier output declaration mismatch")
        require(shapes.get("final_layer_fcF32:weight:") == [16, 10], "classifier final weight shape mismatch")
        require(shapes.get("final_layer_fcF32:bias:") == [10], "classifier final bias shape mismatch")
    else:
        require(shapes.get("conv1d_11_F32:weight:") == [1, 1, 16, 1], "first-stage output shape mismatch")
    return shapes


def audit():
    image_path = ROOT / "artifacts/device/2026-11-09-linux/rtos-analysis/rtos-window.bin"
    image = image_path.read_bytes()
    require(sha(image) == IMAGE_SHA, "fixed image identity mismatch")
    old_path = RESOURCE_ROOT / "audit.json"
    old = json.loads(old_path.read_text())
    require(old["image_sha256"] == IMAGE_SHA, "resource report image mismatch")
    summaries, parsed = [], {}
    for model in old["models"]:
        off, length = int(model["address"], 16) - BASE, model["bytes"]
        encoded = image[off:off + length]
        require(sha(encoded) == model["encoded_sha256"], "encoded resource identity mismatch")
        decoded = transform(encoded)
        require(decoded == (RESOURCE_ROOT / model["file"]).read_bytes(), "decoded archive mismatch")
        require(sha(decoded) == model["decoded_sha256"], "decoded resource identity mismatch")
        require(transform(decoded, encode=True) == encoded, "resource inverse round trip mismatch")
        key = (model["language"], model["kind"])
        parsed[key] = parse_weights(decoded) if model["kind"].endswith("weights") else decoded
        summary = {"language": key[0], "kind": key[1], "address": model["address"],
                   "size_address": model["size_address"], "bytes": length,
                   "decoded_sha256": sha(decoded), "encoded_round_trip_equal": True}
        if isinstance(parsed[key], dict):
            weights = parsed[key]
            require(weights["tensors"] == model["tensors"], "strict tensor parser disagrees with retained metadata")
            summary.update({k: weights[k] for k in ("version", "tensor_count", "float32_count")})
        summaries.append(summary)
    shapes = {}
    for language in ("en", "zh"):
        for stage in (1, 2):
            shapes[language, stage] = model_shape_check(parsed[language, f"stage{stage}_graph"],
                                                        parsed[language, f"stage{stage}_weights"], stage)
    require(shapes["en", 1] == shapes["zh", 1] and shapes["en", 2] == shapes["zh", 2], "language tensor ABI shapes differ")
    for stage in (1, 2):
        require(parsed["en", f"stage{stage}_graph"] == parsed["zh", f"stage{stage}_graph"], "language graphs differ")
    table = list(struct.unpack_from("<5I", image, 0xA07E3C14 - BASE))
    require(table == [1002, 1001, 1004, 1003, 1005], "class semantics table mismatch")
    semantics_path = ROOT / "artifacts/device/2026-11-10-voice-semantics/audit.json"
    semantics = json.loads(semantics_path.read_text())
    require(semantics["image_sha256"] == IMAGE_SHA and semantics["class_to_public_code"] == table,
            "retained semantic evidence mismatch")
    for function in semantics["function_fingerprints"]:
        content = bytearray()
        for span in function["ranges"]:
            low, high = (int(value, 16) for value in span.split("-"))
            content.extend(image[low - BASE:high - BASE + 1])
        require(sha(content) == function["sha256"], "retained semantic function identity mismatch")
    for language in ("en", "zh"):
        rows = [row for row in semantics["synthetic_classification"] if row["language"] == language]
        for winner, result in ((3, 3), (2, 4)):
            require(any(row["winner"] == winner and row["result"] == result for row in rows),
                    "retained START/STOP classification case missing")
    router_path = ROOT / "artifacts/offline/2026-11-10-capture-trigger/audit.json"
    router = json.loads(router_path.read_text())
    for name, expected in router["input_sha256"].items():
        require(sha((ROOT / name).read_bytes()) == expected, "retained C router source identity mismatch")
    require(router["arm_checks"] == 13068 and router["arm_selftest_return"] == 0,
            "retained C router validation mismatch")
    # A finite, shape-preserving weight change remains format-valid and can be
    # re-encoded. This demonstrates that the XOR recurrence itself cannot
    # provide integrity authentication; it does NOT execute a vendor loader.
    original = (RESOURCE_ROOT / "en-stage2_weights.bin").read_bytes()
    first = parsed["en", "stage2_weights"]["tensors"][0]
    changed = bytearray(original)
    value = struct.unpack_from("<f", changed, first["offset"])[0]
    struct.pack_into("<f", changed, first["offset"], value + 0.125)
    changed = bytes(changed)
    require(sha(changed) != sha(original), "mutation did not change model")
    parse_weights(changed)
    require(transform(transform(changed, encode=True)) == changed, "modified host envelope did not round trip")
    # Reject malformed envelopes without assuming the original parser does so.
    negatives = []
    for name, bad in (("truncation", original[:-1]), ("trailing_byte", original + b"x"),
                      ("zero_tensor_count", bytes(4) + original[4:])):
        try:
            parse_weights(bad)
        except ValueError as exc:
            negatives.append({"case": name, "rejected": str(exc)})
        else:
            raise ValueError(f"host parser accepted {name}")
    nan = bytearray(original)
    struct.pack_into("<I", nan, first["offset"], 0x7FC00000)
    try:
        parse_weights(bytes(nan))
    except ValueError as exc:
        negatives.append({"case": "nan_weight", "rejected": str(exc)})
    else:
        raise ValueError("host parser accepted NaN")
    return {"schema": "yi4k.voice-keyword-replacement-preflight/v1",
            "status": "passed_offline_resource_envelope_and_shared_action_checks",
            "image_sha256": IMAGE_SHA, "models": summaries,
            "shared_class_table_address": "0xa07e3c14", "shared_class_to_public_code": table,
            "languages_share_graph_and_tensor_shapes": True,
            "start": {"raw_class": 3, "engine_result": 1003, "message": "0xf0010338", "typed_action": "START"},
            "stop": {"raw_class": 2, "engine_result": 1004, "message": "0xf0010339", "typed_action": "STOP"},
            "reuse_original_recognized_start_requires_keyword_change": False,
            "referenced_validation": {"semantic_function_fingerprints_checked": len(semantics["function_fingerprints"]),
                                      "retained_host_arm_router_checks": router["arm_checks"],
                                      "current_router_sources_match_validated_sources": True,
                                      "new_arm_or_host_router_execution": False},
            "format_preserving_mutation": {"host_parse_passed": True, "inverse_transform_passed": True,
                                            "vendor_parser_executed": False, "acoustic_validity_proven": False,
                                            "modified_model_written": False},
            "negative_host_checks": negatives,
            "gate": {"exact_spoken_phrases_verified": False, "original_parser_executed": False,
                     "runtime_model_load_verified": False, "runtime_integrity_or_signature_gate_known": False,
                     "new_model_training_export_available": False, "custom_phrase_replacement_ready": False,
                     "device_access": False, "target_write": False},
            "scope": ["GUI/PCM/log strings name UI and public actions; they are not an editable recognition lexicon.",
                      "The resource XOR recurrence can be reversed; this does not rule out outer firmware or resource integrity checks.",
                      "Existing stock ARM audits establish language argument selection and class-to-event mapping; this audit only reparses retained envelopes and the class table.",
                      "No waveform, neural inference, custom keyword recognition, RTOS installation or prerecord hardware operation was exercised."],
            "source_hashes": {str(p.relative_to(ROOT)): sha(p.read_bytes()) for p in
                              (Path(__file__), old_path, semantics_path, router_path,
                               ROOT / "sdk/yi4k_capture_trigger.c")}}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    result = audit()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({"status": result["status"], "resources": len(result["models"]),
                      "custom_phrase_ready": False, "device_access": False}))


if __name__ == "__main__":
    main()
