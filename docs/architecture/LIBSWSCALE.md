# libswscale

**Purpose**: Scaling, pixel format conversion, and colorspace conversion for video frames.

## Role

Used when decoder output format differs from filter/encoder requirements, or when explicit scale/format filters run. Architecture-optimized paths (x86 SIMD, etc.) selected at build time.

## Dependencies

libavutil (pixel formats, frames).

## MediaForge relevance

Performance-sensitive. Prefer measuring before changing; many paths already highly optimized.

*Verified against library overview in avutil.h.*
