# Release Testing Checklist

## Maturity

- [ ] VERSION updated (no accidental `-dev` on a stable tag)
- [ ] RELEASE_STATUS.md reflects channel
- [ ] CHANGELOG MediaForge section updated
- [ ] Not labeled stable unless objective gates pass

## Source

- [ ] Clean git working tree for the release commit
- [ ] VERSION matches intended tag (e.g. `v0.1.0-rc.1`)
- [ ] Documentation links valid for release notes

## Build / upstream

- [ ] `FFMPEG_REF` pinned for the release notes
- [ ] CI green on release commit
- [ ] Compiler / platform matrix noted

## Testing

- [ ] `bash tests/regression/run.sh` PASS
- [ ] ASan / malformed job green
- [ ] FATE subset recorded if claimed (else state NOT RUN)
- [ ] Hardware: PASS or intentional SKIP

## Packaging

- [ ] Source archive built (`release.yml` or equivalent)
- [ ] SHA256SUMS present
- [ ] Optional GPG signature only if key available
- [ ] Artifact smoke: unpack, `bash scripts/mediaforge version`

## GitHub

- [ ] Tag pushed
- [ ] Release notes: MediaForge changes + upstream baseline + limitations
- [ ] No secrets in logs or artifacts

## Rollback

- [ ] Known issue path: mark release, publish fix tag, document impact
