# Fuzzing Strategy

## Upstream FFmpeg fuzz infrastructure

FFmpeg ships libFuzzer-oriented harnesses under `tools/` (verified on upstream master):

| Target source | Role |
|---------------|------|
| `tools/target_dec_fuzzer.c` | Decoder fuzzing (codec selected at build time) |
| `tools/target_dem_fuzzer.c` | Demuxer fuzzing via custom `AVIOContext` |
| `tools/target_enc_fuzzer.c` | Encoder fuzzing |
| `tools/target_bsf_fuzzer.c` | Bitstream filter fuzzing |
| `tools/target_sws_fuzzer.c` | libswscale |
| `tools/target_swr_fuzzer.c` | libswresample |
| `tools/target_dec_fate.list` / `target_dec_fate.sh` | FATE-related decoder fuzz helpers |

Harnesses implement `LLVMFuzzerTestOneInput` and typically bound iteration counts (e.g. `maxiteration`) to avoid infinite loops.

**OSS-Fuzz**: Google’s OSS-Fuzz project builds many FFmpeg decoder/demuxer/BSF targets with ASan and continuous corpora. MediaForge should treat OSS-Fuzz results and upstream fixes as first-class inputs when tracking security.

## MediaForge stance (Phase 3)

| Activity | Phase 3 decision |
|----------|------------------|
| Document upstream harnesses | Done (this file) |
| Run multi-hour fuzz in default CI | **No** — cost and flakiness |
| Bounded malformed smoke under ASan | **Yes** — see CI and [SECURITY_TESTING.md](SECURITY_TESTING.md) |
| Local unbounded fuzz in 1.2 GiB workspace | **No** — not practical |
| Optional scheduled workflow later | Allowed if resource-capped |

## Recommended local / CI-adjacent fuzz (when resources allow)

1. Build upstream FFmpeg with Clang and sanitizers, following comments in `target_dec_fuzzer.c`.
2. Start with **small corpora** (empty, few FATE samples, truncated files).
3. Prefer short runs first: `-max_total_time=60` or `-runs=10000`.
4. Always pair with ASan (and ideally UBSan).
5. Triage crashes offline; minimize inputs; never publish weaponized PoCs.

Example shape (illustrative; adjust paths and codec defines):

```bash
# After an ASan-instrumented FFmpeg build with libFuzzer linked per upstream docs:
./tools/target_dem_fuzzer -max_total_time=120 -max_len=65536 corpus_dir
```

## Corpus strategy

| Corpus type | Purpose |
|-------------|---------|
| Empty / 1-byte / random short | Baseline robustness |
| Truncated valid files | Header-only / partial parses |
| FATE samples (where license allows) | Coverage seeds |
| Minimized historical crashers | Regression (keep tiny) |
| OSS-Fuzz public seeds (if redistributable) | Optional |

Do **not** commit large binary corpora to the MediaForge git tree without need. Prefer scripts that fetch or generate tiny fixtures.

## Crash triage process

1. Confirm crash under ASan/UBSan with a **minimized** input.
2. Identify library and function (stack trace).
3. Determine if MediaForge owns the code or upstream does.
4. If upstream: search existing fixes / report through appropriate upstream channels; track CVE if assigned.
5. If MediaForge patch: minimal fix + regression test + sanitizer re-run.
6. Document in [SECURITY_AUDIT.md](SECURITY_AUDIT.md) with severity reasoning.

## Integration roadmap

- **Phase 3**: Documentation + lightweight ASan malformed smoke in CI.
- **Phase 8**: Stronger FATE, optional scheduled fuzz job, corpus policy.
- **Ongoing**: Watch upstream security commits when pinning `FFMPEG_REF`.
