# Corpus Policy

| Rule | Detail |
|------|--------|
| Seeds | Tiny; prefer generated or minimized crashers |
| Git | No large binary corpora in-repo |
| `fuzz/corpus/` | Optional local seeds; `.gitkeep` only by default |
| Dedup | By stack hash / minimized input |
| License | Same as fixtures policy |

Contribution: open an issue with minimized input + stack; do not attach weaponized packs.
