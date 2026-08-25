# Threat Model (Defensive)

Focused on **hostile or malformed media** processed by MediaForge / FFmpeg libraries and tools.

## Assets

| Asset | Why it matters |
|-------|----------------|
| Process integrity | Avoid attacker-controlled code execution via memory corruption |
| Confidentiality of host | Avoid info leaks from OOB reads |
| Availability | Avoid easy crash loops / memory bombs in services |
| Downstream trust | Correct decoding for users who rely on the pipeline |

## Actors and goals

| Actor | Goals | Typical means |
|-------|-------|----------------|
| Malicious file author | Crash, RCE, or DoS when victim opens media | Crafted containers, images, subtitles |
| Malicious stream source | Same over network protocols | Hostile packets / playlists |
| Unskilled / buggy producer | Accidental malformed files | Truncated exports, bad muxers |
| Local untrusted user | Abuse shared transcode service | Upload extreme resolutions / graphs |

## Trust boundaries

1. **Bytes from outside the process** (files, sockets, pipes) are untrusted.
2. **CLI arguments and filter strings** are untrusted if supplied by end users.
3. **Codec private data / extradata** inside containers is untrusted even if the container demuxer “succeeded.”
4. **Internal APIs** assume callers pass sane `AVCodecContext` setup; misuse by applications is out of scope for “media file” vulns but still documented.

## Likely failure modes

| Failure | Severity class | Notes |
|---------|----------------|-------|
| Heap buffer overflow in parser/decoder | Critical / High | Classic media bug class |
| Integer overflow in size calculation | Critical / High | Leads to undersized buffers |
| Use-after-free on error paths | High | Complex cleanup |
| Unlimited allocation from length fields | Medium / High | DoS |
| CPU hang on pathological bitstream | Medium | DoS; may be hard to bound fully |
| Null deref on missing headers | Low / Medium | Usually crash-only if not exploitable |
| Assertion abort on debug builds | Informational | Prefer graceful error in release |

## Mitigations (current + planned)

| Mitigation | Status |
|------------|--------|
| Upstream bounds checks and safe alloc helpers | Inherited when building FFmpeg |
| ASan/UBSan CI smoke | Phase 1; expanded slightly in Phase 3 |
| Documented attack surface & testing guide | Phase 3 |
| Malformed-input smoke tests in CI | Phase 3 (minimal, safe) |
| OSS-Fuzz / libFuzzer harnesses | Upstream; document and optionally replay later |
| Full FATE + continuous fuzz | Phase 8 / ongoing |
| MediaForge-specific patches with regression tests | When justified findings exist |

## Residual risks

- FFmpeg is large; **not all demuxers/codecs can be exhaustively audited** in one phase.
- Hardware paths and network protocols need dedicated environments.
- Resource exhaustion cannot be fully eliminated without application-level limits (timeouts, max resolution, max memory).
- Zero-days in upstream will appear over time; MediaForge must track upstream security fixes when vendoring patches.

## Out of scope for this model

- Social engineering of developers
- Compromised build toolchain / supply chain (handled by normal release engineering)
- Pure cryptographic attacks on DRM systems
- Weaponized exploit development or public exploit packaging

## Severity model (MediaForge)

| Level | Meaning |
|-------|---------|
| **Critical** | Memory corruption or equivalent with credible impact on typical builds |
| **High** | Serious robustness/security issue needing urgent fix |
| **Medium** | Meaningful weakness; limited or hard-to-reach impact |
| **Low** | Minor hardening opportunity |
| **Informational** | Suspicious or incomplete area; no demonstrated security impact |

Severity requires **technical reasoning**, not intuition alone. See [SECURITY_AUDIT.md](SECURITY_AUDIT.md).
