# MediaForge Security Documentation

Defensive security engineering for MediaForge (FFmpeg-based).

| Document | Purpose |
|----------|---------|
| [SECURITY_BASELINE.md](SECURITY_BASELINE.md) | Current testing capabilities and limits |
| [ATTACK_SURFACE.md](ATTACK_SURFACE.md) | Where untrusted data enters the pipeline |
| [THREAT_MODEL.md](THREAT_MODEL.md) | Actors, assets, failure modes, severity scale |
| [FUZZING.md](FUZZING.md) | Upstream harnesses, OSS-Fuzz, MediaForge policy |
| [SECURITY_TESTING.md](SECURITY_TESTING.md) | How to run sanitizers, malformed tests, triage |
| [SECURITY_AUDIT.md](SECURITY_AUDIT.md) | Phase 3 audit report and findings log |

**Principle**: verified finding → minimal fix → regression → sanitizers → docs.  
Do not invent vulnerabilities. Do not publish weaponized exploits.
