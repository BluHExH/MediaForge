# MediaForge Build Guide

This document describes how to build and test the codebase that MediaForge is based on (upstream FFmpeg), how MediaForge CI works, and known resource limitations.

**Status (Phase 1)**: MediaForge does not yet contain a full local copy of the FFmpeg sources. CI clones a pinned upstream revision, configures, builds, and runs smoke tests. When MediaForge begins carrying its own source tree or patches, this guide will be updated.

## Prerequisites

### Common

- Git
- A C compiler (GCC or Clang recommended; MSVC is supported upstream on Windows)
- GNU Make ≥ 3.81
- pkg-config (recommended)
- yasm or nasm (for optimized assembly on x86)

### Linux

```bash
# Debian/Ubuntu
sudo apt-get update
sudo apt-get install -y build-essential yasm nasm pkg-config

# Fedora
sudo dnf install gcc make yasm nasm pkgconfig
```

### macOS

```bash
xcode-select --install   # if needed
brew install nasm pkg-config
```

### Windows

Recommended path for developers: **MSYS2** (MINGW64 environment).

1. Install MSYS2 from https://www.msys2.org/
2. In a MINGW64 shell:

```bash
pacman -S --needed base-devel git mingw-w64-x86_64-gcc mingw-w64-x86_64-nasm mingw-w64-x86_64-pkg-config make
```

Native MSVC builds are also possible (see upstream FFmpeg documentation) but are more involved.

## Obtaining Sources

Until MediaForge vendors or submodules the FFmpeg tree:

```bash
git clone --depth 1 https://github.com/FFmpeg/FFmpeg.git ffmpeg
cd ffmpeg
```

For reproducible work, pin a commit:

```bash
git checkout <commit-sha>
```

## Configure

FFmpeg’s `./configure` is the primary configuration system. It detects the host, compilers, and optional libraries.

Minimal (fast, core paths only):

```bash
./configure \
  --disable-everything \
  --disable-network \
  --disable-autodetect \
  --enable-protocol=file \
  --enable-demuxer=rawvideo,image2 \
  --enable-muxer=rawvideo,null,image2 \
  --enable-decoder=rawvideo \
  --enable-encoder=rawvideo \
  --enable-filter=null,scale,anull \
  --enable-ffmpeg \
  --enable-ffprobe \
  --disable-doc
```

Standard (GPL-enabled, no heavy external libraries):

```bash
./configure \
  --enable-gpl \
  --disable-debug \
  --disable-doc
```

Useful options:

- `--enable-shared` / `--disable-static` — shared libraries
- `--cc=clang` / `--cxx=clang++` — force Clang
- `--extra-cflags="-O2 -g"` — optimization / debug
- `--enable-libx264` etc. — external libraries (must be installed first)
- `./configure --help` — full list

Out-of-tree builds are supported:

```bash
mkdir build && cd build
/path/to/ffmpeg/configure [options]
make -j$(nproc)
```

## Build

```bash
make -j$(nproc)          # Linux
make -j$(sysctl -n hw.ncpu)  # macOS
```

Binaries appear in the source (or build) directory: `ffmpeg`, `ffprobe`, optionally `ffplay`.

## Smoke Tests

```bash
./ffmpeg -version
./ffprobe -version
./ffmpeg -f lavfi -i "testsrc=duration=0.1:size=64x64:rate=10" -f null -
```

## FATE (Full Regression)

Upstream FATE is extensive and requires the fate-suite samples:

```bash
make fate-rsync SAMPLES=/path/to/fate-suite
make fate SAMPLES=/path/to/fate-suite -j$(nproc)
```

MediaForge CI currently runs **smoke tests only**. Full FATE integration is planned for Phase 8.

## Sanitizer Builds

AddressSanitizer + UndefinedBehaviorSanitizer (Linux, GCC/Clang):

```bash
./configure \
  --disable-everything \
  ... (minimal set as above) ...
  --extra-cflags="-O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer" \
  --extra-ldflags="-fsanitize=address,undefined"
make -j$(nproc)
ASAN_OPTIONS=detect_leaks=0:halt_on_error=1 \
UBSAN_OPTIONS=halt_on_error=1 \
  ./ffmpeg -f lavfi -i "color=c=red:s=32x32:d=0.1" -f null -
```

Do not enable every warning as an error against upstream code without careful review; FFmpeg has legitimate constructs that trigger aggressive warning sets.

## CI Usage

GitHub Actions workflow: `.github/workflows/ci.yml`

Jobs (Phase 1 baseline):

| Job | Platform | Config | Purpose |
|-----|----------|--------|---------|
| linux-minimal | Ubuntu | minimal | Fast core breakage detection |
| linux-standard | Ubuntu / GCC | standard GPL | Main Linux build |
| linux-clang | Ubuntu / Clang | standard GPL | Compiler diversity |
| linux-asan | Ubuntu | minimal + ASan/UBSan | Memory / UB hygiene |
| windows | Windows + MSYS2 | minimal | Windows toolchain |
| macos | macOS | minimal | Apple Clang |
| docs-check | Ubuntu | n/a | Required documentation presence |

CI clones upstream FFmpeg (`FFMPEG_REF`, currently `master`), configures, builds, and runs smoke tests. Logs include OS, compiler, and commit information for reproducibility.

To re-run CI: push to `main`/`master`, open a PR, or use “Run workflow” (workflow_dispatch).

## Resource Limitations (Development Workspace)

The interactive development environment used for early MediaForge work has approximately **1.2 GiB RAM and no swap**. Full FFmpeg configure + parallel build frequently exhausts memory.

Consequences:

- Prefer GitHub Actions for complete builds.
- Local work should use minimal configurations or out-of-tree single-threaded builds if attempting compilation.
- Full source checkout of FFmpeg itself can also be slow or incomplete under these constraints.

## Common Errors

| Symptom | Likely cause | Mitigation |
|---------|--------------|------------|
| `nasm/yasm not found` | Missing assembler | Install nasm or yasm; or accept slower pure-C paths |
| `pkg-config` missing for a library | External dep not installed | Install the library + pkg-config file, or disable the feature |
| OOM / killed during `make -jN` | Too little RAM | Reduce parallelism (`-j1` or `-j2`) or use CI |
| Windows path / shell issues | Native cmd vs MSYS2 | Use MSYS2 MINGW64 shell for configure/make |
| Sanitizer reports on first run | Expected for some paths | Investigate; do not silence with broad suppressions without understanding |

## Reproducibility Checklist

When reporting a build failure, include:

1. Exact FFmpeg (or MediaForge) commit
2. OS and architecture (`uname -a`)
3. Compiler version (`gcc --version` / `clang --version`)
4. Full `./configure` command line
5. Relevant environment variables (`CC`, `CFLAGS`, `PKG_CONFIG_PATH`, …)
6. `ffbuild/config.log` (or the last 100 lines)
7. Whether the failure occurs in CI or locally

CI jobs already emit the first three items.

## Next Steps

- Phase 1 establishes this foundation.
- Later phases will introduce MediaForge-specific patches, stronger FATE coverage, additional sanitizer targets, and (when practical) a vendored or submoduled source tree.

---

*Last updated: Phase 1 — Build & CI Foundation*
