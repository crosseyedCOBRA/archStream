# Setup TODO

Things still to set up for the stream. Check items off as they're done.

The setup is two PCs: the **streaming PC** (this Arch box, runs OBS) and the
**gaming PC** (where chat is monitored while live).

## Stream quality

- [ ] **Unified chat with Social Stream Ninja**
  - Streaming PC: install the SSN extension in Chromium and open the Twitch,
    YouTube and Kick pop-out chats in tabs. Keep them open while live.
  - Streaming PC: replace the Streamlabs chat browser source with the SSN
    overlay URL.
  - Gaming PC: open the SSN dock URL (same `?session=`) to read chat.
  - Treat the session ID like a password: keep it out of screenshots and out
    of this repo.
  - Check with a test message from each platform that all three show up.
- [ ] **Mic filter chain** in OBS, in this order: Noise Suppression (RNNoise) →
  Expander / Noise Gate → Compressor → Limiter (-1 dB). Voice peaking around
  -10 to -6 dB, game audio under it.
- [ ] **Encoder setup in Aitum Multistream**
  - One shared H.264 NVENC encode for all three platforms: 900p60 (or 936p60),
    6000 kbps CBR, 2 s keyframes, two-pass quarter resolution, Lanczos
    downscale.
  - Optional: separate HEVC encode for YouTube at ~9000-10000 kbps. Keep it only
    if the Stats dock shows no encoding lag in a demanding game (the GTX 1080
    has one NVENC chip, shared with Aitum Vertical).
- [ ] **Upload speed check**: each platform uploads separately, so bitrates
  add up. Three platforms at 6000 plus vertical is ~22 Mbps; aim for ~30 Mbps
  upload or lower the bitrate.
- [ ] **Audio/video sync across the two PCs**: the capture card adds latency,
  so the webcam and mic can be ahead of the gameplay. Clap on camera with the
  game visible and adjust the Sync Offset in Advanced Audio Properties (and a
  Render Delay filter on the webcam if needed).
- [ ] **Control OBS from the gaming PC**: obs-websocket is already built into
  this OBS. Use a remote (a web remote such as obs-web, Touch Portal or similar)
  on the gaming PC to switch scenes, see dropped frames and start/stop without
  touching the streaming PC.
- [ ] **Socials banner**: built in `overlays/socials-banner.html` (see
  README). Add it to OBS as a browser source.
- [ ] **Record both canvases**
  - 16:9: Settings → Output → Recording (Advanced mode). Use the stream
    encoder so the GTX 1080 does no extra encoding; give it its own encoder
    only if the Stats dock stays clean.
  - Vertical: Aitum Vertical's own recording settings (gear in its dock).
    Reuse its stream encoder if offered; otherwise it's another NVENC encode.
  - Hybrid MP4 (or MKV) so a crash doesn't lose the file.
  - Separate folders, e.g. `~/Videos/Stream/horizontal` and
    `~/Videos/Stream/vertical`.
  - Mic, game and Discord on separate audio tracks in the 16:9 recording for
    editing.
  - Start recording automatically with the stream (Settings → Advanced for the
    main canvas; check Aitum Vertical's settings for the same).
  - Disk space: about 2.7 GB per hour per recording at 6000 kbps.
- [ ] **Redo Twitch and Kick panels**: images are in `branding/panels/out/`
  (About, Schedule, Subscribe, Tips, YouTube, Discord). Upload them to both
  channels with the text and links underneath.
- [x] **Pick a fixed schedule**: Mon/Wed 9-11:30 PM ET, Fri 9 PM-12:30 AM ET,
  weekends flexible 9 PM-12:30 AM ET. It's on the Schedule panel; set the same
  times in each platform's schedule settings too.
- [ ] **Test stream on every platform**: go live unlisted/test and watch each
  one for a minute on a phone over mobile data.

## Streaming PC maintenance

- [ ] **NVIDIA driver guard**: pacman hook that checks `dkms status` after a
  `linux-lts` or `nvidia-580xx` upgrade and warns if the module didn't build,
  plus recovery steps in the README. Make sure nothing can replace the driver
  with `nvidia` / `nvidia-open` (no Pascal support).
- [ ] **Widen the OBS rebuild hook**: add `mbedtls3`, `libdatachannel`,
  `luajit`, `rnnoise`, `jansson`, `x264` and `python` to
  `hooks/obs-rebuild-warning.hook`.
- [ ] **Back up the OBS config**: script that copies scene collections and
  profiles from `~/.config/obs-studio` into this repo, excluding
  `service.json` and anything else holding stream keys.
- [ ] **Plugin rebuild reminder** when OBS itself moves to a new version
  (`obs-vertical-canvas`, `obs-aitum-multistream-bin`).
- [ ] **Write `STREAMING.md`** with the final encoder, bitrate and output
  settings once they're settled.

## Nice to have

- [ ] Starting Soon / BRB / Ending scenes and a privacy scene, if not already set up.
- [ ] Live captions with the LocalVocal plugin (would need building against
  this OBS).
