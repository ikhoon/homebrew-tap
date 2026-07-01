# homebrew-tap

Homebrew tap for [`ikhoon`](https://github.com/ikhoon)'s macOS CLIs & tools:

- [`maccal`](https://github.com/ikhoon/maccal) — scriptable macOS **Calendar** CLI (EventKit).
- [`macmail`](https://github.com/ikhoon/macmail) — scriptable macOS **Mail.app** CLI.
- [`macrec`](https://github.com/ikhoon/macrec) — always-on macOS **meeting recorder** (menu-bar app + CLI): mic + system audio, transcribed locally with `whisper.cpp`.

## Install

```bash
brew install ikhoon/tap/maccal
brew install ikhoon/tap/macmail
brew install ikhoon/tap/macrec
```

- **maccal** — after install, authorize Calendar access once: `maccal auth`.
- **macmail** — run a read command (e.g. `macmail triage`) and grant **Full Disk Access**
  to "macmail" when prompted.
- **macrec** — launch the app (`open $(brew --prefix)/opt/macrec/macrec.app`), grant
  **Screen & System Audio Recording · Microphone · Calendar**, then enable "Start at login"
  in its Settings. First run downloads the transcription model (~1.6 GB).

## Notes

- **maccal**: universal (arm64 + x86_64), prebuilt and codesigned `maccal.app` from the
  maccal GitHub release. It holds its own Calendar (TCC) grant via `maccal.app` — it does
  not grant your terminal calendar access.
- **macmail**: **Apple Silicon (arm64) only**, prebuilt and codesigned `macmail.app` from
  the macmail release.
- **macrec**: **Apple Silicon (arm64) only**, self-contained self-signed `macrec.app` from
  the macrec release — bundles a static `whisper-cli` (Metal) + silero VAD; the large model
  downloads on first run. It's a menu-bar app (launch it), with a `macrec` CLI for scripting.
- All are prebuilt downloads, not source builds — Homebrew's build sandbox blocks the
  network during `install`, and the prebuilt download also avoids Gatekeeper (Homebrew's
  curl doesn't quarantine the file).

## Updating a formula on a new release

1. `shasum -a 256 <name>-<version>-macos-*.zip`
2. Bump `url` and `sha256` in `Formula/<name>.rb`; commit and push.
