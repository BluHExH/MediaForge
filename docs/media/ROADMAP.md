# Media Feature Roadmap

Scoring: user value × feasibility × compatibility × security × performance (qualitative).

## Phase 6 (selected)

| Item | Score rationale | Action |
|------|-----------------|--------|
| Human-readable **inspect** | High value, zero codec risk | `mediaforge inspect` via ffprobe |
| **Thumbnail** helper | High value, standard CLI pattern | `mediaforge thumbnail` |
| **Extract audio** helper | High value, simple | `mediaforge extract-audio` |
| Inventory + upstream strategy | Required for sustainable fork | Docs |

## Near term (after source vendor)

| Item | Notes |
|------|--------|
| Metadata preserve defaults in recipes | Still prefer explicit ffmpeg flags |
| Safer network input docs / timeouts | App-level limits |
| Subtitle extract recipe + malformed tests | No custom parser |

## Explicitly deferred

| Item | Why |
|------|-----|
| New video codec | Upstream domain; huge surface |
| Custom subtitle renderer | Security + duplication |
| New streaming stack | Out of scope |
| “AI enhance” filters | Not core reliability work |

## Rejected for Phase 6

- Rewriting libavcodec/libavformat/libavfilter  
- Shipping large media samples in git  
- Claiming features that only exist when optional libs are linked without documenting dependencies  
