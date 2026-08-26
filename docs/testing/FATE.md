# FATE (FFmpeg Automated Testing Environment)

## What FATE is

Upstream regression system under FFmpeg `tests/`: reference samples, `fate` make targets, per-test expectations. It is the authoritative correctness suite for libav* behavior.

## MediaForge stance

| Claim | Phase 8 reality |
|-------|-----------------|
| Full FATE passed on every PR | **False / not run** |
| FATE infrastructure understood | Documented |
| Optional CI job for FATE | `.github/workflows/fate.yml` (manual + weekly) |
| Default PR CI | Smoke + sanitizers + MediaForge tests only |

## Why full FATE is not on every commit

- Large sample set and long runtime  
- Needs a configured FFmpeg build tree + fate samples  
- MediaForge workspace RAM (~1.2 GiB) cannot host full clone+FATE comfortably  
- GitHub Actions minutes cost  

## Practical levels

| Level | Content | When |
|-------|---------|------|
| L0 Smoke | lavfi → null, version | Every CI job |
| L1 MediaForge | cli/media/hardware/regression scripts | Every CI |
| L2 Mini-FATE | Optional: build FFmpeg + `make fate` filtered subset in `fate.yml` | schedule / dispatch |
| L3 Full FATE | Full upstream suite | Dedicated machine / future self-hosted |

## Running upstream FATE (operator)

```bash
git clone https://github.com/FFmpeg/FFmpeg.git && cd FFmpeg
./configure --samples=/path/to/fate-suite   # see upstream docs
make -j$(nproc)
make fate                                   # or fate-rsync + specific targets
```

Follow official FFmpeg testing documentation for sample download (`fate-rsync`) and target names.

## Reporting rule

Only report FATE results for the exact targets and commit that were executed. Never equate MediaForge smoke tests with “FATE passed.”
