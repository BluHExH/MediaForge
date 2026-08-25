# Threading and Concurrency

## Codec threading

- **Frame threading**: parallel decode/encode of independent frames.  
- **Slice threading**: parallel work within a frame.  

Controlled by `AVCodecContext.thread_count` and `thread_type`. Capability flags on `AVCodec` indicate support.

## Filter threading

Graphs may enable internal multithreading; individual filters declare slice capabilities. libavutil provides `slicethread` helpers.

## libavutil executor

`executor.c` / `executor.h` provide a small task executor used by some components.

## Safety notes

- Most contexts are **not** free-threaded: one thread owns a given `AVCodecContext` / graph unless documented otherwise.  
- Refcounted objects (`AVFrame`, `AVPacket`, `AVBuffer`) are safe to pass between threads with proper ref/unref discipline.  
- Avoid concurrent `av_log` configuration changes.

## MediaForge stance

Do not change threading models without benchmarks and stress tests. Prefer documenting and testing existing behavior first.

*Verified against avcodec threading flags documentation and libavutil slicethread/executor presence.*
