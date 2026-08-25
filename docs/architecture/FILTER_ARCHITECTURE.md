# Filter Architecture

## Graph construction

1. `avfilter_graph_alloc`
2. Create filters (`avfilter_graph_create_filter`) or parse a string (`avfilter_graph_parse_ptr`)
3. Link pads
4. `avfilter_graph_config` — negotiates formats and prepares execution

## Frame movement

- Source filters produce frames onto output links.  
- Intermediate filters receive on input links, process, push to outputs.  
- Sink filters hold frames until the application pulls them (`av_buffersink_get_frame`).

Format negotiation ensures each link has a single agreed pixel/sample format, rate, dimensions, and time base.

## Example

```
buffer → scale=iw/2:ih/2 → format=yuv420p → buffersink
```

Applications feed the buffer source with `av_buffersrc_add_frame` and pull from buffersink.

## Threading

Filter graphs can use internal slice/frame parallelism depending on filter capabilities and graph options. See THREADING.md.

## MediaForge note

New filters are a primary extension point. Follow existing filter boilerplates under `libavfilter/` and add FATE coverage.

*Verified against libavfilter role and standard graph APIs.*
