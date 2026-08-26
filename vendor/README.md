# vendor/

## ffmpeg/

Full **FFmpeg** source tree at the MediaForge pinned baseline (`config/upstream.env`).

| File | Meaning |
|------|---------|
| `.mediaforge-upstream-ref` | Upstream tag (e.g. `n7.1.5`) |
| `.mediaforge-upstream-commit` | Immutable SHA |

Populate or refresh:

```bash
bash scripts/vendor-ffmpeg.sh
```

Build:

```bash
cd vendor/ffmpeg
./configure --disable-network --enable-ffmpeg --enable-ffprobe # ...
make -j"$(nproc)"
```

Upstream license texts ship inside this tree (`LICENSE.md`, `COPYING.*`). See [docs/architecture/SOURCE_INTEGRATION_PLAN.md](../docs/architecture/SOURCE_INTEGRATION_PLAN.md).
