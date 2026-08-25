# MediaForge Baseline Report (Phase 0)

**Date**: 2026-08-25  
**Upstream**: Official FFmpeg repository (https://github.com/FFmpeg/FFmpeg)  
**Working project name**: MediaForge  
**Phase**: 0 — Repository Discovery  

## Name Suitability Assessment

The working name **MediaForge** was evaluated for conflicts:

- Multiple existing projects use "MediaForge" or "mediaforge":
  - Desktop GUI wrappers around FFmpeg (mediaforge.video)
  - Discord bots, Next.js toolkits, TypeScript FFmpeg wrappers
  - Image/metadata tools, library organizers, AI media pipelines
- No major competing *core multimedia framework* or FFmpeg-derived library uses the exact name as a production framework.
- Trademark risk is moderate for consumer-facing tools but lower for a developer/library-oriented open-source project that clearly attributes upstream FFmpeg.
- Decision for Phase 0–8: Retain **MediaForge** as working name. Final branding decision deferred to Phase 9. Alternatives considered (AvForge, CodecForge, etc.) remain available if conflicts become blocking.

## Repository Structure (Upstream FFmpeg)

Top-level layout (inspected via GitHub API on master, SHA approx. a1050d48...):

| Path | Type | Role |
|------|------|------|
| configure | script | Autoconf-style configure system (very large, ~300 KB) |
| Makefile | build | Top-level recursive Makefile |
| ffbuild/ | dir | Build system helpers, common.mak, etc. |
| libavutil/ | library | Core utilities (memory, math, logging, pixel formats, etc.) |
| libavcodec/ | library | Codecs (decoders/encoders), parsers, bitstream filters |
| libavformat/ | library | Muxers, demuxers, protocols, formats |
| libavfilter/ | library | Audio/video filters and filtergraph |
| libavdevice/ | library | Input/output devices |
| libswscale/ | library | Scaling, colorspace conversion |
| libswresample/ | library | Audio resampling, format conversion |
| fftools/ | tools | ffmpeg, ffprobe, ffplay CLIs |
| doc/ | docs | Man pages, developer docs, examples |
| tests/ | tests | FATE regression tests, samples references |
| tools/ | utils | Various helper tools |
| compat/ | compat | Platform compatibility shims |
| presets/ | presets | Encoding presets |
| .forgejo/ | CI | Forgejo/GitHub Actions-style workflows |
| LICENSE.md, COPYING.* | legal | Multi-license (LGPL 2.1+/GPL 2+/3, etc.) |
| INSTALL.md, README.md, CONTRIBUTING.md, MAINTAINERS, Changelog | meta | Project docs |

Additional architecture-specific and platform code lives under the lib* directories (e.g. x86/, arm/, aarch64/, neon, SSE, AVX assembly, CUDA, VA-API, VideoToolbox, D3D, Vulkan, etc.).

## Build System

- Primary: `./configure` + `make`
- Highly configurable: hundreds of `--enable-*` / `--disable-*` options for codecs, formats, filters, hardware, external libs.
- Generates `config.h`, `config.mak`, library Makefiles.
- Supports shared/static, PIC, cross-compilation, many toolchains.
- Optional: NASM/YASM for assembly, external libraries (libx264, libvpx, libaom, freetype, etc.).

### Typical build (baseline, unmodified)

```bash
./configure --enable-gpl --enable-libx264 --enable-shared  # example
make -j$(nproc)
make install  # optional DESTDIR
```

Dependencies vary widely by enabled features. Minimal build needs only a C compiler, make, and basic POSIX tools. Full feature builds require many external libraries.

## Supported Platforms (upstream)

- Linux (primary development)
- Windows (MSVC, MinGW, Cygwin)
- macOS / iOS (VideoToolbox)
- Android, BSD variants, Haiku, Solaris, etc.
- Architectures: x86/x86_64, ARM/AArch64, PowerPC, MIPS, RISC-V, and others with varying optimization levels.

## Major Components

- **Libraries**:
  - libavutil — foundation
  - libavcodec — >100 codecs
  - libavformat — containers + protocols (file, http, rtmp, hls, dash, ...)
  - libavfilter — extensive filtergraph (scale, overlay, drawtext, aresample, ...)
  - libavdevice — v4l2, alsa, pulse, dshow, avfoundation, ...
  - libswscale / libswresample
- **CLI tools**: ffmpeg (transcoder), ffprobe (analyzer), ffplay (player)
- **Hardware acceleration**: CUDA/NVENC/NVDEC, VA-API, VDPAU, QSV, VideoToolbox, AMF, Vulkan, D3D11/12, MediaCodec, etc.
- **Assembly optimizations**: extensive hand-written SIMD for performance-critical paths.

## Testing Strategy (upstream)

- **FATE** (FFmpeg Automated Testing Environment): large regression suite comparing outputs against reference samples.
- Unit-style tests in tests/
- Some fuzzing infrastructure historically (OSS-Fuzz integration exists in ecosystem).
- No single modern "unit test framework" covering all; heavy reliance on FATE + manual + continuous integration.

## Known Limitations / Considerations for MediaForge

- Extremely large codebase; changes must be surgical.
- License mix: many components LGPL, some GPL, some with additional restrictions (e.g. certain external libs). Full redistribution requires careful license compliance.
- Configure system is powerful but complex and not the most modern (no CMake primary).
- Performance is already highly optimized; further gains require careful profiling.
- Security: media parsers are attack surface; upstream takes security seriously but continuous audit is valuable.
- API stability: public APIs (libav*) have versioning and deprecation policy; breaking changes need strong justification.
- Environment note (this workspace): full source checkout/extraction is resource-constrained (low RAM ~1.2 GiB, no swap). Phase 0 baseline is therefore derived from GitHub tree inspection + official documentation + system ffmpeg binary. Full local source tree and clean builds will be established in subsequent phases when environment or CI permits.

## Build Dependencies (typical)

- Compiler: GCC or Clang (MSVC supported)
- make
- pkg-config
- Optional: yasm/nasm, texinfo (docs), external codec libs, SDL (ffplay), etc.

## Performance Considerations (baseline)

- Decode/encode heavily optimized with SIMD and hardware paths.
- Threading via frame/slice threading and filter threading.
- Memory usage can be significant for high-resolution / high-bitrate / complex filtergraphs.
- Startup cost of configure + large binary size for full builds.

## Licensing Structure

- Core: primarily LGPL 2.1 or later (or GPL 2/3 when GPL components enabled).
- Individual files may carry additional notices.
- External libraries have their own licenses (e.g. x264 GPL, aom BSD, etc.).
- Must preserve all license texts, copyright notices, and source availability obligations.
- MediaForge will maintain full upstream attribution and document any modifications.

## Next Steps (Phase 0 completion)

1. Create development journal and roadmap documents.
2. Establish GitHub repository under working name.
3. Push baseline documentation.
4. Proceed to Phase 1 (Build & CI foundation) once source availability is improved.

---

*This baseline intentionally contains no functional source modifications. All observations are derived from upstream structure and public documentation.*
