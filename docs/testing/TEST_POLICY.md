# Test Policy

| Outcome | Meaning |
|---------|---------|
| **PASS** | Assertion held |
| **FAIL** | Unexpected failure — must investigate |
| **SKIP** | Optional resource missing (GPU, encoder) — report separately |
| **NOT RUN** | Job/target not scheduled |

## Rules

1. Never delete or weaken tests solely to green CI.  
2. SKIP requires a technical reason logged in output.  
3. Flaky tests: fix determinism; temporary quarantine must be documented with owner/date.  
4. Every MediaForge bugfix needs a regression when feasible.  
5. Security fixes need sanitizer-backed checks when feasible.  
6. Do not treat SKIP as PASS in reports.
