# VideoDB — video & audio SDK reference

Perception + memory + actions for video, live streams, and desktop sessions. Use this whenever you need to
ingest files/URLs/live streams, build visual/spoken indexes, search with timestamps, edit timelines, add
overlays/subtitles, generate media, transcode, or monitor real-time streams.

## Table of Contents

- [Setup](#setup)
- [Connect & upload](#connect--upload)
- [Transcript & subtitles](#transcript--subtitles)
- [Index & search (timestamps + evidence)](#index--search)
- [Timeline editing](#timeline-editing)
- [Transcode & reframe](#transcode--reframe)
- [Generative media](#generative-media)
- [Streaming & playback](#streaming--playback)
- [Live streams (RTSP/RTMP)](#live-streams-rtstream)
- [Desktop capture (macOS)](#desktop-capture-macos)
- [Error handling & pitfalls](#error-handling--pitfalls)
- [When to use what](#when-to-use-what)

## Setup

```bash
pip install "videodb[capture]" python-dotenv
# if [capture] fails on Linux: pip install videodb python-dotenv
```

Set `VIDEO_DB_API_KEY` (get at https://console.videodb.io) via env export or a project `.env`.
Never read/write/handle the API key yourself — let the user set it.

Always load env and connect from the project directory before SDK code:

```python
from dotenv import load_dotenv
load_dotenv(".env")
import videodb
conn = videodb.connect()
```

For anything longer than ~3 statements use a heredoc (`python << 'EOF' ... EOF`), else inline `python -c`.

## Connect & upload

```python
coll = conn.get_collection()

# URL, YouTube, or local file
video = coll.upload(url="https://example.com/video.mp4")
video = coll.upload(url="https://www.youtube.com/watch?v=VIDEO_ID")
video = coll.upload(file_path="/path/to/video.mp4")
```

## Transcript & subtitles

```python
video.index_spoken_words(force=True)   # force=True skips if already indexed
text = video.get_transcript_text()
stream_url = video.add_subtitle()       # returns a stream with subtitles burned/inline
```

Custom subtitle styling (white text on black background is a common request) goes through `add_subtitle`
style options or a `CaptionAsset` in the editor (see Timeline editing).

## Index & search

Indexes are the precondition for search. `index_scenes()` has **no force parameter** — if it raises
"Scene index already exists", recover the id from the error:

```python
import re
from videodb import SearchType, IndexType, SceneExtractionType
from videodb.exceptions import InvalidRequestError

video.index_spoken_words(force=True)

try:
    scene_index_id = video.index_scenes(
        extraction_type=SceneExtractionType.shot_based,
        prompt="Describe the visual content in this scene.",
    )
except Exception as e:
    match = re.search(r"id\s+([a-f0-9]+)", str(e))
    scene_index_id = match.group(1) if match else (raise ... )
```

Search always returns shots with timestamps and a compiled stream. Use `score_threshold=0.3+` for semantic
scene search to filter noise. `search()` raises `InvalidRequestError` when nothing matches — treat it as empty.

```python
results = video.search("product demo")
shots = results.get_shots()
stream_url = results.compile()           # compiled clip of all hits

results = video.search(
    query="person writing on a whiteboard",
    search_type=SearchType.semantic,
    index_type=IndexType.scene,
    scene_index_id=scene_index_id,
    score_threshold=0.3,
)
```

Clip a specific hit: `shot = shots[0]; clip = shot.extract_clip(start, end)`.
Cross-collection: search on `coll.search(...)` instead of `video.search(...)`.

## Timeline editing

Compose clips and overlays into one output stream. **Always validate timestamps first** — negative values are
silently accepted but produce broken output.

```python
from videodb.timeline import Timeline
from videodb.asset import VideoAsset, TextAsset, AudioAsset, ImageAsset, TextStyle

timeline = Timeline(conn)
timeline.add_inline(VideoAsset(asset_id=video.id, start=10, end=30))      # trim + place on main track
timeline.add_overlay(0, TextAsset(text="The End", duration=3,
                                  style=TextStyle(fontsize=36, color="#FFFFFF")))
stream_url = timeline.generate_stream()
```

Key asset parameters:
- **VideoAsset**: `asset_id`, `start`, `end`, `disable_other_tracks` (mute other tracks when True).
- **TextAsset**: `text`, `duration`, `style` (fontsize, color, position x/y, stroke, etc.).
- **AudioAsset**: `url`/`file_path`, `start`, `disable_other_tracks`. Set `disable_other_tracks=False` to mix
  music with the video's own audio.
- **ImageAsset**: `url`/`file_path`, `start`, `duration`, x/y.
- **CaptionAsset** (editor API): word-level caption track from a transcript; used with a
  `Timeline` + tracks + clips for styled captions. Simplest subtitle path is `video.add_subtitle()`.

Transitions, speed changes, crop/zoom, colour grading, and volume mixing are **not** supported server-side —
fall back to ffmpeg/moviepy for those.

## Transcode & reframe

```python
from videodb import TranscodeMode, VideoConfig, AudioConfig

job_id = conn.transcode(
    source="https://example.com/video.mp4",
    callback_url="https://example.com/webhook",
    mode=TranscodeMode.economy,
    video_config=VideoConfig(resolution=720, quality=23, aspect_ratio="16:9"),
    audio_config=AudioConfig(mute=False),
)
```

`reframe()` is slow server-side — **always reframe a short segment** or use `callback_url` for async:

```python
from videodb import ReframeMode

reframed = video.reframe(start=0, end=60, target="vertical", mode=ReframeMode.smart)
# presets: "vertical" (9:16), "square" (1:1), "landscape" (16:9)
# custom: target={"width": 1280, "height": 720}
# async full-length: video.reframe(target="vertical", callback_url="https://...")
```

## Generative media

```python
image = coll.generate_image(prompt="a sunset over mountains", aspect_ratio="16:9")
coll.generate_voice(text="...", voice="...")            # voiceover
coll.generate_music(prompt="...", duration=30)          # background music
coll.generate_sound_effect(prompt="...")
coll.generate_video(prompt="...")                       # plan-gated
coll.generate_text(prompt="...", response_type="json")  # LLM on collection context
```

Dubbing: `video.dub_video(language="hi")`; translate a transcript via the collection LLM.
Some features (generate_video, create_collection) are plan-gated — surface limits to the user.

## Streaming & playback

```python
stream_url = video.generate_stream()              # playable HLS link
stream_url = video.generate_stream(segment_start=10, segment_end=30)  # specific segment
# timelines and search results also have generate_stream() / compile()
```

Open in browser with `import webbrowser; webbrowser.open(stream_url)`.

## Live streams (RTStream)

```python
rtstream = coll.connect_rtstream(rtsp_url="rtsp://...", name="cam-1")
rtstream.start()
# ... recording ...
rtstream.stop()
stream_url = rtstream.generate_stream()           # for recorded segment
result = rtstream.export_video(duration=60)       # export to a real video
```

Live AI pipelines: `rtstream.index_audio(...)` / `rtstream.index_visuals(...)` build scene indexes that emit
events/alerts (people entering zones, spoken keywords). Live transcription via `rtstream.start_transcription()`
with paged `get_transcript_pages()` and `stop_transcription()`. Use cases: real-time monitoring, event detection,
content moderation, profanity alerts.

## Desktop capture (macOS)

Captures screen + mic + system audio, stores episodic session memory, runs real-time alerts.

```bash
python scripts/ws_listener.py &   # start WebSocket listener (dumps to /tmp/videodb_events.jsonl)
cat /tmp/videodb_ws_id            # WebSocket id for the capture client
```

Events are queried from the JSONL file:

```python
import json, time
events = [json.loads(l) for l in open("/tmp/videodb_events.jsonl")]
transcripts = [e["data"]["text"] for e in events if e.get("channel") == "transcript"]
recent_visual = [e for e in events if e.get("channel") == "visual_index"
                 and e["unix_ts"] > time.time() - 300]
```

Produces session summaries, a searchable timeline, and playable evidence links. Desktop capture is **macOS only**.

## Error handling & pitfalls

```python
from videodb.exceptions import AuthenticationError, InvalidRequestError
try:
    conn = videodb.connect()
except AuthenticationError:
    print("Check your VIDEO_DB_API_KEY")
```

| Scenario | Error | Solution |
|---|---|---|
| Indexing an already-indexed video | "Spoken word index already exists" | `index_spoken_words(force=True)` |
| Scene index exists | "Scene index with id XXXX already exists" | Extract id with `re.search(r"id\s+([a-f0-9]+)", str(e))` |
| No search matches | `InvalidRequestError: No results found` | Catch → `shots = []` |
| Reframe times out | blocks on long videos | Use start/end segment, or `callback_url` async |
| Negative Timeline timestamps | silent broken stream | Validate `start >= 0` before building assets |
| `generate_video()` / `create_collection()` fail | "Operation not allowed"/"maximum limit" | Plan-gated — tell the user |

## When to use what

| Problem | VideoDB solution |
|---|---|
| Platform rejects aspect ratio/resolution | `video.reframe()` or `conn.transcode()` + `VideoConfig` |
| Resize for Twitter/Instagram/TikTok | `reframe(target="vertical"\|"square")` |
| 1080p → 720p | `conn.transcode()` with `VideoConfig(resolution=720)` |
| Overlay music on video | `AudioAsset` on a `Timeline` |
| Add subtitles | `video.add_subtitle()` or `CaptionAsset` |
| Combine/trim clips | `VideoAsset` on a `Timeline` |
| Voiceover, music, SFX | `coll.generate_voice()/generate_music()/generate_sound_effect()` |
| Transcribe + searchable moments | `index_spoken_words()` + `search()` |
