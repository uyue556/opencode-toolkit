# Voice Agents & Audio Processing

Building real-time voice agents (STT → LLM → TTS), low-latency optimization, provider selection, and audio transcription to documents. Consolidated from `voice-ai-development`, `audio-transcriber`, `pipecat-friday-agent`, `fal-audio`, `auri-core`.

## Table of contents

1. [Architecture and provider selection](#architecture-and-provider-selection)
2. [Latency optimization](#latency-optimization)
3. [OpenAI Realtime API](#openai-realtime-api)
4. [Component pipeline (Deepgram + ElevenLabs)](#component-pipeline-deepgram--elevenlabs)
5. [Multi-provider orchestration with Pipecat](#multi-provider-orchestration-with-pipecat)
6. [Voice agent validation checks](#voice-agent-validation-checks)
7. [Audio transcription → Markdown reports](#audio-transcription--markdown-reports)

---

## Architecture and provider selection

Voice apps feel magical when fast, broken when slow — optimize relentlessly for perceived responsiveness. Think in latency budgets, audio quality, and interruption handling.

| Approach | Providers | When |
|---|---|---|
| Integrated voice (native voice-to-voice) | OpenAI Realtime API | Simplest; one stream, no separate STT/TTS glue |
| Phone-based agents (hosted) | Vapi (+ Twilio for PSTN) | Quick deployment, call centers |
| Best-in-class component pipeline | Deepgram STT + ElevenLabs TTS + LLM | High quality, full control |
| Custom real-time infrastructure | LiveKit (WebRTC) + STT/TTS | Building your own voice app |
| Pipeline framework | Pipecat (Mic → VAD → STT → LLM → TTS → Speaker) | Multi-provider, granular stage control |
| Cloud TTS/STT | fal.ai audio models | Quick STT/TTS jobs |

**Real-time integration:** WebRTC (browser/app), WebSockets (server streams), telephony (SIP/PSTN).

**Key provider facts:** Vapi hosts voice agents with webhooks and `firstMessage`; Deepgram `nova-2` for transcription with `interim_results` and VAD; ElevenLabs `eleven_turbo_v2_5` is the fastest model with streaming; LiveKit provides rooms/tokens for WebRTC agents.

---

## Latency optimization

1. **Stream everywhere** — STT, LLM, and TTS on streaming APIs only; non-streaming TTS adds significant latency.
2. **Start TTS before the LLM finishes** — send TTS a ~50-char buffer or on sentence boundaries (`.!?`), not the full response.
3. **Use PCM audio format** (`pcm_24000`, `linear16@16k`) to avoid encoding overhead; match sample rates between providers (e.g., TTS output 24kHz ↔ app output device).
4. **Keep WebSockets alive** with reconnection logic (exponential backoff); wrap in try/except for `ConnectionClosed`.
5. **Use regional endpoints** close to your users.
6. **VAD tuning** matters for UX: configure `threshold`, `prefix_padding_ms`, `silence_duration_ms` so the model doesn't cut off or hang.

**Voice response style:** short, data-dense sentences; avoid polite fillers — they add latency and dilute the format.

---

## OpenAI Realtime API

Session over WebSocket (`wss://api.openai.com/v1/realtime?model=...`), send `session.update` configuring modalities (`text`+`audio`), voice, PCM formats, server VAD turn detection, and function tools. Then push `input_audio_buffer.append` chunks and consume events: `response.audio.delta` (play), `response.audio_transcript.done`, `input_audio_buffer.speech_started`, `response.function_call_arguments.done` (handle the tool call and reply with `conversation.item.create` function_call_output). Barge-in = user starts speaking → stop current TTS.

---

## Component pipeline (Deepgram + ElevenLabs)

- **Deepgram realtime:** `deepgram.listen.live.v("1")` with `nova-2`, `smart_format`, `interim_results`, `vad_events`, `utterance_end_ms`, `encoding=linear16`, `sample_rate=16000`. Handle `is_final` transcripts.
- **ElevenLabs streaming:** `text_to_speech.convert_as_stream(voice_id, model_id="eleven_turbo_v2_5", output_format="pcm_24000")`, or the WebSocket `stream_async` interface for chunk-by-chunk (flush on sentence end).
- Voice agents must handle **interruption (barge-in):** detect speech while speaking → stop the current response and clear the audio queue.

---

## Multi-provider orchestration with Pipecat

`pip install pipecat-ai[openai,google,silero]`. Linear pipeline: Mic → VAD → STT → LLM → TTS → Speaker.

- Use Silero VAD locally (robust, blocks background noise from triggering the LLM).
- Cross-provider gotcha: some aggregators expect a specific message shape — write a compatibility shim translating between OpenAI-style dicts and the other provider's schema (e.g., `GoogleSafeContext`/`GoogleSafeMessage` for Gemini).
- Match `audio_out_sample_rate` to the TTS output (24kHz) or audio comes out high-pitched/slowed.
- Troubleshooting: choppy audio → wrong output-device index; "validation error" → message-format shim not applied.

---

## Voice agent validation checks

| Check | Why | Fix |
|---|---|---|
| Non-streaming TTS | Adds significant latency | Use `synthesize_stream`/`convert_as_stream` |
| Hardcoded sample rate | Format mismatches | Define constants; document formats |
| WebSocket without reconnection | Drops after transient failure | Retry with exponential backoff |
| Missing VAD configuration | Poor UX (cutoffs, hang) | Tune threshold + `silence_duration_ms` |
| Blocking audio processing | Freezes the loop | Make processing async |
| Missing interruption handling | Can't barge-in | Add barge-in detection + cancel + clear queue |
| Audio queue without clear | Stale audio after interrupt | Add a clearable queue |
| WebSocket without error handling | Crash on `ConnectionClosed` | try/except + reconnect |

---

## Audio transcription → Markdown reports

Zero-config transcription (Faster-Whisper preferred, ~4–5× faster than OpenAI Whisper; `ffmpeg` for format conversion — install with `pip install faster-whisper` / `openai-whisper`).

**Workflow:** detect tools → validate file (exists, format, `ffprobe` duration, warn > ~25 MB) → transcribe → generate structured Markdown + optional SRT/VTT subtitles.

**Output template:** metadata table (file, size, duration, language, speakers, engine), meeting minutes (participants, topics with timestamps, decisions, action items with assignees/due dates), and an executive summary via an LLM pass. Name outputs with a timestamp (`transcript-YYYYMMDD-HHMMSS.md`) to avoid overwrites. Supports local files and URLs, batch processing (`recordings/*.mp3`), and speaker annotation when diarization is available.

**Voice-optimized output (SSML) hint:** for TTS playback, wrap spoken prompts with prosody and pauses (`<prosody rate="medium" pitch="+2%">…</prosody><break time="300ms"/>`) to make synthesized speech feel natural.