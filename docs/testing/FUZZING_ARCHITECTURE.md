# Fuzzing Architecture

Builds on [docs/security/FUZZING.md](../security/FUZZING.md).

## Targets (upstream)

| Source | Domain |
|--------|--------|
| `tools/target_dec_fuzzer.c` | Decoders |
| `tools/target_dem_fuzzer.c` | Demuxers |
| `tools/target_bsf_fuzzer.c` | Bitstream filters |
| `tools/target_enc_fuzzer.c` | Encoders |
| `tools/target_sws_fuzzer.c` / `target_swr_fuzzer.c` | Scale / resample |

OSS-Fuzz continuously fuzzes FFmpeg; MediaForge should track upstream fixes when pinning.

## MediaForge Phase 8

| Activity | Status |
|----------|--------|
| Document architecture | Yes |
| Bounded CI fuzz (hours) | **Not** enabled (cost/noise) |
| Malformed ASan smoke | Yes (ci.yml) |
| Corpus directory | `fuzz/corpus/` placeholder only |

## Bounded local fuzz (operators)

Use upstream harness + ASan + `-max_total_time=60` … `300`. Convert crashes via [CRASH_TRIAGE.md](CRASH_TRIAGE.md).
