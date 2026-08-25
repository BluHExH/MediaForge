# libavdevice

**Purpose**: Access to capture and playback devices through the same demuxer/muxer interfaces as files (AVFormatContext).

Examples: Video4Linux2, ALSA, PulseAudio, DirectShow, AVFoundation, DeckLink, framebuffer, etc. Availability depends on configure and platform.

## Interaction

libavdevice builds on libavformat. Device “formats” are registered as input/output formats. Applications use `avformat_open_input` / mux APIs with device URLs.

## MediaForge relevance

Platform-specific; changes need real hardware or good mocks. Low–medium priority for early MediaForge work unless targeting a specific capture path.

*Verified against library list in avutil.h and tree presence of libavdevice.*
