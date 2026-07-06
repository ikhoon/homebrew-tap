# Homebrew cask for macrec — the always-on menu-bar meeting recorder *and* the
# macrec CLI:
#   brew install --cask ikhoon/tap/macrec
#
# Installs macrec.app — a self-contained, self-signed bundle: a static whisper-cli
# (Metal embedded) + the silero VAD model; the large transcription model downloads
# on first run — and exposes the `macrec` CLI (config / engine / perm-status …) on
# your PATH. macrec is a menu-bar app first, so (unlike maccal) there is no
# separate CLI-only formula: this one cask gives you both the app and the command.
#
# After a new release: run ./package.sh in the macrec repo, upload the zip to the
# GitHub release as macrec-<version>-macos-arm64.zip, then bump `version` +
# `sha256` below (the release workflow does this automatically).
cask "macrec" do
  version "0.5.0"
  sha256 "b1d9d978b2196ebdf9bd048f132f7c4e1eec52eb994f68553e723d46d2d79a5a"

  url "https://github.com/ikhoon/macrec/releases/download/v#{version}/macrec-#{version}-macos-arm64.zip"
  name "macrec"
  desc "Always-on meeting recorder with local whisper.cpp transcription"
  homepage "https://github.com/ikhoon/macrec"

  depends_on arch:  :arm64
  depends_on macos: :sequoia

  app "macrec.app"
  # Expose the CLI bundled inside the app on PATH, so the one cask gives you both
  # the menu-bar app and the `macrec` terminal command.
  binary "#{appdir}/macrec.app/Contents/MacOS/macrec"

  # Ad-hoc signed (not notarized): strip the quarantine flag so Gatekeeper does
  # not block first launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/macrec.app"]
  end

  uninstall quit: "com.ikhoon.macrec"

  zap trash: [
    "~/Library/Application Support/macrec",
    "~/Library/LaunchAgents/com.ikhoon.macrec.plist",
    "~/Library/Preferences/com.ikhoon.macrec.plist",
    "~/Library/Preferences/com.ikhoon.macrec.prefs.plist",
  ]
end
