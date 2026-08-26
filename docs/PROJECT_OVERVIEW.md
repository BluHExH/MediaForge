# Project Overview

## What MediaForge is today

Transitioning toward an **in-tree FFmpeg baseline** (`vendor/ffmpeg`, pin n7.1.5). Until the full tree is committed, CI may still clone the pin. See [architecture/SOURCE_INTEGRATION_PLAN.md](architecture/SOURCE_INTEGRATION_PLAN.md).


A **pre-release** open-source project that:

1. Documents and CI-builds **upstream FFmpeg**
2. Adds MediaForge-specific **helpers** (`scripts/mediaforge`)
3. Maintains **architecture, security, performance, testing, hardware** documentation
4. Runs **honest** smoke/regression tests (and records what is *not* run, e.g. full FATE)

## What MediaForge is not

- Not a claim of authorship of FFmpeg  
- Not a full independent codec implementation  
- Not a stable product release (see [RELEASES.md](RELEASES.md))  
- Not guaranteed GPU acceleration without devices/drivers  

## Relationship to FFmpeg

MediaForge **builds on** the [FFmpeg](https://ffmpeg.org/) multimedia framework. Codecs, demuxers, filters, and the `ffmpeg`/`ffprobe` CLIs are upstream work. MediaForge-specific value is process, tooling, and documentation unless/until source patches are explicitly added under the upstream strategy.

## Architecture (summary)

See [architecture/README.md](architecture/README.md): libavutil → libavcodec → libavformat / libavfilter / devices / swscale / swresample → fftools.

## Current MediaForge capabilities

- Multi-platform CI (Linux/Windows/macOS) + ASan malformed smokes  
- Optional performance and FATE-policy workflows  
- Helpers: inspect, thumbnail, extract-audio, hwinfo, recipes, passthrough  
- Test suites: cli, media, hardware (skip GPU), regression aggregate  

## Limitations

- No vendored modified libav* tree in-repo yet  
- Full FATE not part of default CI  
- Hardware runtime unverified on GPU-less runners  

## Roadmap

See [ROADMAP.md](ROADMAP.md). Engineering loop: measure → implement → test → review → document → push.
