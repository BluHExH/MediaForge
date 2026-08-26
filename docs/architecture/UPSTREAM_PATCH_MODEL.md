# Upstream Patch Model

## Baseline

Exact FFmpeg release imported under `vendor/ffmpeg/` matching `config/upstream.env`.

## Distinguishing changes

| Kind | How identified |
|------|----------------|
| Upstream files | Match release tag content |
| MediaForge changes | Git commits with `mediaforge:` subject prefix, or files under MediaForge-owned paths outside `vendor/ffmpeg/` |
| Re-vendor events | Commit message `vendor: ffmpeg <tag> (<sha>)` |

## Rules

1. Prefer **additive** MediaForge code outside `vendor/ffmpeg/` when possible.  
2. In-tree edits must be **minimal**, justified, and tested.  
3. On upstream update: replace tree from new tag, re-apply MediaForge commits/patches, run full regression.  
4. Do not rewrite unrelated upstream style or “cleanup” churn.  
5. Security fixes: prefer official release tags; cherry-pick only with clear notes.

## Synchronization flow

```
New FFmpeg tag → update upstream.env → vendor-ffmpeg.sh →
build → tests → sanitizers → FATE subset → review → push
```
