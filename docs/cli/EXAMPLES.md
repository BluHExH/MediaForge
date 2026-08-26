# CLI Examples

Examples below were checked against **system ffmpeg/ffprobe 6.1.1** in the MediaForge workspace (2026-08-26). Adjust codec names if your build lacks `libx264` / lavfi.

Prefer `-nostdin` in scripts so ffmpeg does not consume stdin unexpectedly.

## Inspect media

```bash
ffprobe -hide_banner input.mp4
ffprobe -v quiet -print_format json -show_format -show_streams input.mp4
```

Generated probe (no file):

```bash
ffprobe -v quiet -print_format json -show_format -show_streams -f lavfi -i "sine=f=440:d=0.1"
```

## Convert / remux

```bash
# Remux without re-encode (when codecs compatible)
ffmpeg -nostdin -y -i input.mkv -c copy output.mp4

# Re-encode H.264 + AAC (common distribution pair)
ffmpeg -nostdin -y -i input.mov -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k output.mp4
```

## Extract audio

```bash
ffmpeg -nostdin -y -i input.mp4 -vn -c:a copy output.m4a
ffmpeg -nostdin -y -i input.mp4 -vn -c:a libmp3lame -q:a 2 output.mp3
```

## Resize

```bash
ffmpeg -nostdin -y -i input.mp4 -vf "scale=1280:-2" -c:v libx264 -crf 23 -c:a copy output.mp4
```

## Trim

```bash
# Fast seek (keyframe-aligned; may be inexact)
ffmpeg -nostdin -y -ss 00:00:10 -i input.mp4 -t 00:00:30 -c copy clip.mp4

# Accurate (decode path)
ffmpeg -nostdin -y -i input.mp4 -ss 00:00:10 -t 00:00:30 -c:v libx264 -c:a aac clip.mp4
```

## Compress (CRF)

```bash
ffmpeg -nostdin -y -i input.mp4 -c:v libx264 -preset slow -crf 28 -c:a aac -b:a 96k small.mp4
```

## Filter example

```bash
ffmpeg -nostdin -y -i input.mp4 -vf "fps=15,scale=640:-2" -c:v libx264 -an preview.mp4
```

## Thumbnail

```bash
ffmpeg -nostdin -y -i input.mp4 -ss 00:00:05 -frames:v 1 thumb.jpg
```

Generated:

```bash
ffmpeg -nostdin -y -f lavfi -i "color=s=32x32:d=0.1" -frames:v 1 /tmp/thumb.png
```

## GIF (simple)

```bash
ffmpeg -nostdin -y -i input.mp4 -vf "fps=10,scale=320:-1:flags=lanczos" -loop 0 out.gif
```

## Subtitles (soft mux)

```bash
ffmpeg -nostdin -y -i video.mp4 -i subs.srt -c copy -c:s mov_text out.mp4
```

## Progress for automation

```bash
ffmpeg -nostdin -y -i input.mp4 -c:v libx264 -progress pipe:1 -nostats out.mp4
```

## Overwrite control

```bash
ffmpeg -n -i in.mp4 -c copy out.mp4   # fail if out exists
ffmpeg -y -i in.mp4 -c copy out.mp4   # overwrite
```

## Batch pattern

```bash
for f in *.avi; do
  ffmpeg -nostdin -y -i "$f" -c:v libx264 -c:a aac "${f%.avi}.mp4" || exit 1
done
```

## MediaForge helper (optional)

```bash
./scripts/mediaforge help
./scripts/mediaforge recipes
./scripts/mediaforge probe -f lavfi -i "sine=f=440:d=0.1"
```
