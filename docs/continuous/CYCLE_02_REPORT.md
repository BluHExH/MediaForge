# Continuous Cycle 02 — Report

## Current baseline

| Field | Value |
|-------|--------|
| Tag | `n7.1.5` |
| Commit | `3a0867c2bfda4a4d4309ca1a8cbdc6175e67f587` |
| Config | `config/upstream.env` |

## Previous behavior

CI used `FFMPEG_REF=master` (moving tip).

## Selection rationale

Official release tag on the maintained 7.1 line; not `*-dev`; resolved to an immutable SHA.

## CI

Workflows load `config/upstream.env` before clone. `scripts/check-upstream-baseline.sh` fails if `FFMPEG_REF` is `master`/`main`.

Optional: `.github/workflows/upstream-tip.yml` (informational, `continue-on-error`).

## Regression (local workspace)

Uses system ffmpeg for MediaForge helper tests (unchanged):

| Suite | Result |
|-------|--------|
| CLI | PASS |
| Media | PASS |
| Hardware | PASS + SKIP (no GPU) |
| Regression aggregate | PASS |
| check-upstream-baseline.sh | PASS |

Full matrix build of **n7.1.5** executes on GitHub Actions after push (not re-simulated fully in this workspace).

## Sanitizers / FATE

Policy unchanged: ASan job in `ci.yml` builds the **pinned** tree. Full FATE still not claimed. Optional `fate.yml` uses the same pin.

## Performance

No performance claim. Pinning is for determinism, not speed.

## Security

Baseline change updates dependency surface; prefer monitoring upstream 7.1.x security commits when updating the pin.

## Release

`release.yml` loads the same `config/upstream.env` and writes `dist/PROVENANCE.txt` (`ffmpeg_ref`, `ffmpeg_commit`).

## Reproducibility

Improved: known tag + SHA for every CI/release path. Still not bit-for-bit archive reproducibility across OS/toolchains.

## Future updates

Follow `docs/continuous/UPSTREAM_UPDATE.md`.
