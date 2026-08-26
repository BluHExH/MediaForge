# Release Testing Checklist

- [ ] Clean configure/build on target platforms  
- [ ] `tests/cli/smoke.sh` PASS  
- [ ] `tests/media/smoke.sh` PASS  
- [ ] `tests/hardware/smoke.sh` PASS or intentional SKIP  
- [ ] `tests/regression/run.sh` PASS  
- [ ] ASan job green  
- [ ] Malformed-input smoke green  
- [ ] Optional FATE subset recorded (document targets)  
- [ ] CHANGELOG updated  
- [ ] `FFMPEG_REF` pinned for the release artifact  
- [ ] No known Critical security regressions  
- [ ] Docs links resolve  
