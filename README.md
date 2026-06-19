# homebrew-tap

Homebrew tap for [`macmail`](https://github.com/ikhoon/macmail) — a fast,
scriptable CLI for macOS Mail.app.

## Install

```bash
brew install ikhoon/tap/macmail
```

Then run a read command (e.g. `macmail triage`) and grant **Full Disk Access**
to "macmail" when prompted.

## Notes

- **Apple Silicon (arm64) only.** Installs a prebuilt, codesigned `macmail.app`
  from the macmail GitHub release.
- Not a source build — Homebrew's build sandbox blocks network during `install`,
  so `bun install` can't run; the prebuilt download also avoids Gatekeeper
  (Homebrew's curl doesn't quarantine the file).

## Updating the formula on a new macmail release

1. `shasum -a 256 macmail-<version>-macos-arm64.zip`
2. Bump `version`, `url`, and `sha256` in `Formula/macmail.rb`; commit and push.
