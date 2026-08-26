# Contributing to MediaForge

Thank you for helping improve MediaForge.

## Engineering philosophy

**measure → implement → test → review → document → push**

Prefer small, tested changes. Do not weaken tests to pass CI.

## Setup

See [docs/DEVELOPMENT/GETTING_STARTED.md](docs/DEVELOPMENT/GETTING_STARTED.md) and [docs/build/BUILDING.md](docs/build/BUILDING.md).

## Tests you should run

```bash
bash tests/regression/run.sh
```

For behavior touching media helpers, also reason about malformed inputs and exit codes.

## Expectations

| Area | Expectation |
|------|-------------|
| Compatibility | Do not break `ffmpeg`/`ffprobe` semantics |
| Attribution | Credit upstream FFmpeg; no false claims |
| Security | No secret commits; follow SECURITY.md |
| Performance | Claims need measurements ([docs/performance/](docs/performance/)) |
| Docs | Update relevant `docs/` pages and CHANGELOG for user-visible changes |
| Commits | Clear messages; logical commits |

## Pull requests

Use the PR template. Describe tests run and compatibility impact.

## Code of conduct

See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
