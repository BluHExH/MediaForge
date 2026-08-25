# Build Architecture

## Flow

```
./configure [options]
  → probes compiler, arch, libraries, headers
  → writes config.h, config.mak, ffbuild/*.mak
make
  → recursive Makefiles build each library and tool
  → optional fate tests
```

## Key pieces

| Path | Role |
|------|------|
| `configure` | Feature detection and option parsing (large shell script) |
| `ffbuild/` | Shared makefile fragments, common rules |
| `Makefile` | Top-level targets |
| `lib*/Makefile` | Per-library objects and conditionals |
| `config.h` | Generated C defines (`CONFIG_*`, `HAVE_*`, `ARCH_*`) |

## Detection

- Compiler and flags  
- Architecture and CPU extensions (selects assembly)  
- External libraries via pkg-config or manual paths  
- Platform APIs (VAAPI, VideoToolbox, …)

## Assembly

Hand-written SIMD under `lib*/x86/`, `arm/`, `aarch64/`, etc., gated by configure results.

## MediaForge stance

Do not replace the configure system in early phases. CI must exercise both minimal and standard configs. Document any new options carefully.

*Verified against INSTALL.md, tree layout, and Phase 1 CI practice.*
