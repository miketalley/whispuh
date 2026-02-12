# Whispah

**Free, offline speech-to-text for macOS.** Press a hotkey, speak, and your words appear wherever your cursor is. No cloud, no account, no subscription — just a 740 KB app powered by [whisper.cpp](https://github.com/ggml-org/whisper.cpp) running entirely on your Mac.

## Why Whispah?

Voice dictation apps are expensive. Whispah is not.

| App | Cost | Requires Internet |
|---|---|---|
| [Wispr Flow](https://wisprflow.ai/pricing) | $144/year | Yes |
| [SuperWhisper](https://superwhisper.com/) | $85/year or $249 lifetime | No |
| [MacWhisper Pro](https://goodsnooze.gumroad.com/l/macwhisper) | $30+ one-time | No |
| **Whispah** | **Free, forever** | **No** |

That's up to **$144/year back in your pocket** — and your voice data never leaves your machine.

## Download

**[Download Whispah v0.1.0](https://github.com/miketalley/whispah/releases/download/v0.1.0/Whispah-v0.1.0.dmg)** — macOS 14+ &bull; 740 KB

Open the `.dmg`, drag Whispah to Applications, and launch. On first run it downloads the Whisper model (~148 MB) — after that, everything runs offline.

## How It Works

1. **Option + Space** — starts recording (a floating pill appears at the top of your screen)
2. **Speak** — say whatever you want transcribed
3. **Option + Space again** — stops recording, transcribes your speech, and pastes the text right where you left off

That's it. Three steps. No setup wizard, no sign-in, no onboarding flow.

## Features

- **100% free and open source** — MIT licensed, no premium tier, no "upgrade to unlock"
- **Fully offline** — all transcription happens on-device via whisper.cpp. Nothing is sent anywhere
- **Tiny footprint** — 740 KB app, menu bar only, no dock icon, near-zero idle resource usage
- **Works everywhere** — dictate into any text field: VS Code, Safari, Slack, Notes, Terminal — if you can type in it, you can speak into it
- **Clipboard-safe** — saves your clipboard before pasting and restores it after, so you never lose what you copied
- **Non-activating overlay** — the recording indicator floats above your work without stealing focus

## Permissions

Whispah needs two permissions on first launch:

| Permission | Why |
|---|---|
| **Microphone** | To record your voice (macOS will prompt automatically) |
| **Accessibility** | To simulate Cmd+V in other apps (grant in System Settings > Privacy & Security > Accessibility) |

## Build from Source

Requires [XcodeGen](https://github.com/yonaskolb/XcodeGen), Xcode 16+, and macOS 14+.

```bash
git clone https://github.com/miketalley/whispah.git
cd whispah
xcodegen generate
open Whispah.xcodeproj
```

Build and run from Xcode (Cmd+R).

### Dependencies

Managed via Swift Package Manager — resolved automatically by Xcode:

- [SwiftWhisper](https://github.com/exPHAT/SwiftWhisper) — Swift wrapper for whisper.cpp
- [KeyboardShortcuts](https://github.com/sindresorhus/KeyboardShortcuts) — global hotkey registration

## Architecture

```
Whispah/
├── WhispahApp.swift              # App entry point
├── AppDelegate.swift             # Menu bar setup
├── AppState.swift                # Central state coordinator
├── HotkeyManager.swift           # Option+Space hotkey
├── AudioRecorder.swift           # Mic capture → 16kHz mono PCM
├── ModelManager.swift            # Whisper model download/cache
├── TranscriptionService.swift    # whisper.cpp transcription
├── TextPaster.swift              # Focus restore + simulated paste
├── PermissionChecker.swift       # Mic + Accessibility checks
└── Views/
    ├── RecordingOverlayView.swift     # Floating pill UI
    └── OverlayPanelController.swift   # Non-activating NSPanel
```

## License

MIT
