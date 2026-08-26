# Crash Triage

1. **Reproduce** under ASan/UBSan with the same binary.  
2. **Minimize** input (half-split / `llvm-reduce` / afl-tmin).  
3. **Identify** library and function from stack.  
4. **Classify** severity (see security severity model).  
5. **Upstream vs MediaForge** ownership.  
6. **Fix** minimally; do not disable sanitizers.  
7. **Regression** test with minimized input (tiny).  
8. **Re-fuzz** nearby targets when practical.  
9. **Document** in SECURITY_AUDIT / CHANGELOG as appropriate.

Do not publish weaponized exploit write-ups in this repository.
