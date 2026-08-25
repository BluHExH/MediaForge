# libavfilter

**Purpose**: Graph-based processing of AVFrames (and sometimes AVPackets for audio). Sources, sinks, and intermediate filters with automatic format negotiation.

## Important concepts

- **AVFilter** — filter definition (name, inputs/outputs, callbacks).
- **AVFilterContext** — instance in a graph.
- **AVFilterLink** — connection between two pads; carries negotiated format, time_base, dimensions, etc.
- **AVFilterGraph** — collection of filters and links.
- **Format negotiation** — graph config picks compatible pixel/sample formats across links.
- **Sources / sinks** — e.g. `buffer` / `buffersink`, `abuffer` / `abuffersink`; also `movie`, `lavfi` test sources.
- **Scheduling** — push/request model; filters process when frames are available or requested.

## Example graph

```
[in] → scale=640:360 → format=yuv420p → [out]
```

Built with `avfilter_graph_parse_ptr` or by creating filters and links manually, then `avfilter_graph_config`.

Frames enter via a source filter, propagate through links, and exit at a sink. Hardware frames can pass through if filters advertise HW support.

## Dependencies

libavutil; often libavcodec; optionally libswscale and libswresample for conversion filters.

## MediaForge relevance

**Preferred extension surface** for many improvements: new filters, better diagnostics, graph helpers. Medium risk if carefully tested with FATE-style graphs.

*Verified against library role in avutil.h mainpage and standard filter APIs.*
