# Security Policy

## Supported versions

MediaForge is **pre-release**. Security fixes are applied on a best-effort basis to `main`. Pin deployments to a known git SHA.

## Reporting a vulnerability

Please **do not** open a public GitHub issue for exploitable vulnerabilities.

Prefer responsible disclosure:

1. Email the repository owner via the GitHub profile associated with this project, **or** use GitHub’s private vulnerability reporting if enabled on the repository.
2. Include: MediaForge commit SHA, OS/arch, command line, input class (not necessarily a full weaponized file), crash/sanitizer log, and impact assessment.
3. Allow reasonable time for triage before public discussion.

## Scope

| In scope | Out of scope |
|----------|--------------|
| MediaForge helpers/scripts/CI | Issues only in unmodified upstream FFmpeg (report upstream when appropriate) |
| MediaForge docs that mislead security posture | Social engineering of maintainers |
| Build/test infrastructure secrets handling | Attacks requiring physical access |

Upstream FFmpeg issues should primarily follow [FFmpeg security practices](https://ffmpeg.org/).

## Safe harbor

Good-faith research that avoids privacy violations and service disruption is appreciated. Do not include exploit packs in public tickets.
