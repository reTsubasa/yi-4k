#!/usr/bin/env python3
"""Read voice/recording settings from a stock YI 4K without changing state.

The probe opens a normal API session, reads app_status and msg_id=3, then
closes the session. It never calls a setter, recorder, voice command, RTC
operation, RTOS shell, or startup script.
"""
from __future__ import annotations

import argparse
import datetime
import json
from pathlib import Path

from device_eis_live_capture import CameraAPI


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--host", default="192.168.42.1")
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    args.output.parent.mkdir(parents=True, exist_ok=True)
    events = []
    report = {
        "schema": 1,
        "started_utc": datetime.datetime.now(datetime.timezone.utc).isoformat(),
        "host": args.host,
        "device_access": True,
        "writes": False,
        "recording_requested": False,
        "voice_command_requested": False,
        "rtc_write_requested": False,
        "api_events": events,
    }
    api = CameraAPI(args.host, events)
    try:
        api.open_session()
        before = api.call(1, type="app_status")
        settings_reply = api.call(3)
        rows = settings_reply.get("param", [])
        flat = {}
        for row in rows:
            if isinstance(row, dict):
                flat.update(row)
        report["status_before"] = before
        report["voice_keys"] = {k: v for k, v in flat.items()
                                if any(token in k.lower() for token in ("voice", "speech", "keyword", "command", "wakeup"))}
        report["sound_keys"] = {k: v for k, v in flat.items()
                                if any(token in k.lower() for token in ("sound", "buzzer", "mic"))}
        report["record_keys"] = {k: v for k, v in flat.items()
                                 if any(token in k.lower() for token in ("rec", "loop", "pre"))}
        report["clock_keys"] = {k: v for k, v in flat.items() if "clock" in k.lower() or k == "camera_clock"}
        report["firmware"] = flat.get("sw_version")
        report["hardware"] = flat.get("hw_version")
        report["settings_count"] = len(flat)
        after = api.call(1, type="app_status")
        report["status_after"] = after
        report["status_unchanged"] = before == after
        report["finished_utc"] = datetime.datetime.now(datetime.timezone.utc).isoformat()
    finally:
        try:
            api.close()
        finally:
            args.output.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")
    print(json.dumps({k: report.get(k) for k in
                      ("status_before", "status_after", "status_unchanged", "voice_keys", "sound_keys", "record_keys", "clock_keys")},
                     ensure_ascii=False))


if __name__ == "__main__":
    main()
