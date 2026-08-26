# Quickstart

Requires `ffmpeg` and `ffprobe` on `PATH` (system package or a MediaForge CI build).

```bash
git clone https://github.com/BluHExH/MediaForge.git
cd MediaForge

# Optional helper
bash scripts/mediaforge version
bash scripts/mediaforge recipes

# Inspect (file path)
bash scripts/mediaforge inspect your.mp4

# Thumbnail
bash scripts/mediaforge thumbnail your.mp4 thumb.jpg --time 00:00:01

# Extract audio
bash scripts/mediaforge extract-audio your.mp4 audio.wav

# Hardware capability list (no GPU required to run the command)
bash scripts/mediaforge hwinfo

# Standard FFmpeg remains primary
ffmpeg -i your.mp4 -c:v libx264 -c:a aac out.mp4
ffprobe -v quiet -print_format json -show_format -show_streams your.mp4
```

Tests:

```bash
bash tests/regression/run.sh
```

More: [docs/cli/EXAMPLES.md](../cli/EXAMPLES.md), [docs/build/BUILDING.md](../build/BUILDING.md).
