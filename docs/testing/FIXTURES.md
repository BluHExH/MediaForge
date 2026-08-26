# Fixture Policy

| Rule | Detail |
|------|--------|
| Prefer generated | `lavfi` testsrc2, sine, color |
| Max committed binary | Avoid >100 KB unless justified |
| License | No copyrighted media without rights |
| Determinism | Fixed sizes, durations, seeds |
| Provenance | Document generator command in test script |
| Updates | Change generator + expected behavior together |

Malformed tests: tiny random/truncated buffers only — no exploit packs.
