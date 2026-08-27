# MF-S5-01 — Smart pipeline planning (design only)

## Problem

MediaForge users often request scale/transcode when the source already matches the target (resolution/codec). Forced scale is expensive relative to passthrough on measured workloads.

## Evidence

Pinned FFmpeg 7.1.5, MediaForge configure:

| Workload | wall (s) |
|----------|----------|
| 720p 5s → null | ~0.10 |
| 720p 5s → scale 640×360 → null | ~0.52 |

Ratio ≈ **5×** for scale vs identity path on this synthetic load.

## Hypothesis

If `inspect` shows width/height/codec already match requested output, skipping `-vf scale` / re-encode reduces wall time proportionally without quality loss.

## Proposed change (MediaForge helper — not FFmpeg C)

1. Extend `mediaforge` (e.g. future `process` or flags on existing helpers) to accept target constraints.
2. Run probe (existing JSON schema).
3. If already satisfied → emit ffmpeg command **without** scale/encode; else build full graph.
4. Log the decision: `pipeline: passthrough` vs `pipeline: scale+encode`.

## Compatibility

- Opt-in flag preferred (`--smart` / `--skip-redundant`) so scripts stay explicit.
- Default behavior of passthrough ffmpeg remains unchanged.

## Risks

- Incorrect skip if probe incomplete (e.g. missing stream) → must fail closed to full pipeline.
- Container vs codec mismatch must still remux when needed.

## Benchmark plan

Same A/B/D workloads with and without smart skip on matching vs non-matching inputs.

## Test plan

CLI + media regression; new cases: match → no scale in argv; mismatch → scale present.

## Status

**Design only in Stage 5.** Not implemented in this pass (audit gate prioritizes evidence over code volume).
