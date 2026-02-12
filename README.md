# Whispah

**Offline speech-to-text for macOS.** Press a hotkey, speak, and your words appear wherever your cursor is. No cloud, no subscriptions — powered by [whisper.cpp](https://github.com/ggml-org/whisper.cpp) running entirely on your Mac.

## Download

**[Download Whispah v0.1.0](https://github.com/miketalley/whispah/releases/download/v0.1.0/Whispah-v0.1.0.dmg)** — macOS 14+

Open the `.dmg`, drag Whispah to Applications, and launch it. On first run it will download the Whisper model (~148 MB) automatically.

## How It Works

1. **Option + Space** — starts recording (a floating pill appears at the top of your screen)
2. **Speak** — say whatever you want transcribed
3. **Option + Space again** — stops recording, transcribes your speech, and pastes the text into whatever app you were using

That's it. Your clipboard is preserved — Whispah saves it before pasting and restores it after.

## Features

- **Fully offline** — all transcription happens locally via whisper.cpp, nothing leaves your Mac
- **Works anywhere** — dictate into any text field: editors, browsers, chat apps, terminal
- **Menu bar app** — lives in your menu bar, no dock icon, stays out of your way
- **Non-activating overlay** — the recording indicator doesn't steal focus from your current app
- **Clipboard-safe** — saves and restores your clipboard contents around each paste

## Permissions

Whispah needs two permissions on first launch:

| Permission | Why |
|---|---|
| **Microphone** | To record your voice (macOS will prompt automatically) |
| **Accessibility** | To simulate Cmd+V in other apps (grant in System Settings > Privacy & Security > Accessibility) |

## Build from Source

Requires Xcode 16+ and macOS 14+.

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
