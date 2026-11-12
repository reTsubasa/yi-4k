# Repository artifact policy

The repository keeps source code, scripts, documentation, APK deliverables, and small machine-readable evidence summaries. Local emulator disks, SDK/tool installations, firmware dumps, raw camera captures, generated build folders, and repeated MP4 fixtures remain outside Git because they are machine-specific or exceed GitHub's file-size limits.

Evidence documents record the original local path, scope, hashes, and limitations. Re-running a validation script produces the omitted binary fixtures locally; an absent raw capture must never be interpreted as a successful device run. The current Android deliverable is the 0.5.0 APK and its build receipt under `artifacts/android/`; 0.4.9 remains as a historical receipt.
