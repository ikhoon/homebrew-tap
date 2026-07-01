# homebrew-tap

Homebrew tap for [`ikhoon`](https://github.com/ikhoon)'s macOS CLIs:

- [`maccal`](https://github.com/ikhoon/maccal) — scriptable macOS **Calendar** CLI (EventKit).
- [`macmail`](https://github.com/ikhoon/macmail) — scriptable macOS **Mail.app** CLI.

## Install

```bash
brew install ikhoon/tap/maccal
brew install ikhoon/tap/macmail
```

- **maccal** — after install, authorize Calendar access once: `maccal auth`.
- **macmail** — run a read command (e.g. `macmail triage`) and grant **Full Disk Access**
  to "macmail" when prompted.

## Notes

- **maccal**: universal (arm64 + x86_64), prebuilt and codesigned `maccal.app` from the
  maccal GitHub release. It holds its own Calendar (TCC) grant via `maccal.app` — it does
  not grant your terminal calendar access.
- **macmail**: **Apple Silicon (arm64) only**, prebuilt and codesigned `macmail.app` from
  the macmail release.
- Both are prebuilt downloads, not source builds — Homebrew's build sandbox blocks the
  network during `install`, and the prebuilt download also avoids Gatekeeper (Homebrew's
  curl doesn't quarantine the file).

## Updating a formula on a new release

1. `shasum -a 256 <name>-<version>-macos-*.zip`
2. Bump `url` and `sha256` in `Formula/<name>.rb`; commit and push.
