# Testing Architecture

```
MediaForge helpers / docs / CI
        │
        ├─► CLI smoke          (options, exit codes, JSON probe)
        ├─► Media smoke        (inspect, thumbnail, extract-audio)
        ├─► Hardware smoke     (list + software; SKIP runtime GPU)
        ├─► Regression runner  (aggregates MediaForge scripts)
        │
Upstream FFmpeg binary (CI-built or system)
        │
        ├─► ASan/UBSan smoke + malformed inputs
        ├─► FATE (optional / scheduled; subset or full off-CI)
        └─► libFuzzer targets (upstream tools/; external/OSS-Fuzz)
```

| Layer | Catches |
|-------|---------|
| CLI/media smoke | Broken helper scripts, missing tools, bad exit handling |
| ASan/UBSan | Memory/UB on exercised paths |
| FATE | Codec/format/filter regressions in upstream tree |
| Fuzzing | Unexpected crashes on mutated inputs |
| Perf workflow | Gross throughput changes (informational) |

Failures must remain visible. SKIP is only for missing optional resources (GPU, encoder not built).
