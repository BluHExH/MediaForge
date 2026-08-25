# Video / Pixel Format Architecture

## Pixel formats

`AVPixelFormat` enumerates packed and planar layouts (YUV, RGB, gray, HW formats, etc.). Descriptors in `pixdesc.h` give planes, depth, chroma subsampling, and flags.

## Planar vs packed

- **Planar**: separate planes (e.g. YUV420P: Y, U, V).  
- **Packed**: interleaved components (e.g. YUYV422).

## Color properties

Frames/contexts carry color primaries, transfer characteristics, matrix coefficients, range (full/limited), chroma location — used by converters and filters.

## libswscale

Converts between pixel formats and scales. Called explicitly or via `scale` / `format` filters.

## Hardware frames

HW pixel formats reference frames in device memory. System ↔ device copies go through `av_hwframe_transfer_data`. See HARDWARE_ACCELERATION.md.

*Verified against pixfmt.h / pixdesc presence and avutil overview.*
