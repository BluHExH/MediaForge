#!/usr/bin/env bash
# Minimal FFmpeg configure for MediaForge helper + smoke tests (not a full feature build).
# Run from an extracted FFmpeg source tree (e.g. vendor/ffmpeg or /tmp extract).
set -euo pipefail

./configure \
  --disable-everything \
  --disable-network \
  --disable-x86asm \
  --disable-doc \
  --disable-autodetect \
  --enable-ffmpeg \
  --enable-ffprobe \
  --enable-avcodec \
  --enable-avformat \
  --enable-avutil \
  --enable-avfilter \
  --enable-avdevice \
  --enable-swscale \
  --enable-swresample \
  --enable-zlib \
  --enable-protocol=file \
  --enable-indev=lavfi \
  --enable-demuxer=rawvideo,image2,wav,matroska \
  --enable-muxer=null,rawvideo,image2,wav,matroska,mjpeg \
  --enable-filter=null,anull,color,sine,testsrc2,scale,aresample,format,aformat \
  --enable-decoder=rawvideo,pcm_s16le,mjpeg,png,mpeg4,wrapped_avframe \
  --enable-encoder=rawvideo,pcm_s16le,mjpeg,png,mpeg4,wrapped_avframe \
  --enable-parser=mpegaudio,mpeg4video \
  "$@"
