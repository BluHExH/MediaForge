# API / ABI Policy

| Interface | Stability |
|-----------|-----------|
| Upstream libav* C API/ABI | Governed by FFmpeg major versions — **not** MediaForge |
| `ffmpeg` / `ffprobe` CLI | Upstream; MediaForge avoids breaking wrappers |
| `scripts/mediaforge` | Shell interface; SemVer for MediaForge-owned contracts only |
| MediaForge C library | **None** shipped |

Do not promise libavcodec ABI stability under the MediaForge name.
