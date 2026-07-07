# Homebrew cask for maccal — the menu-bar app *and* the maccal CLI:
#   brew install --cask ikhoon/tap/maccal-app
#
# Installs maccal.app (which bundles the maccal CLI) and exposes that CLI on your
# PATH, so one command gives you both the GUI sync app and the `maccal` terminal
# command. If you only want the CLI (no app), use the formula instead:
#   brew install ikhoon/tap/maccal
# Both provide `maccal` on PATH, so install one or the other — not both.
cask "maccal-app" do
  version "0.11.0"
  sha256 "705246c299b890a34ef9a9f0943186d9c21732174dd48724a2ef880e5489dfc6"

  url "https://github.com/ikhoon/maccal/releases/download/v#{version}/maccal-menubar-v#{version}-macos-universal.zip"
  name "maccal"
  desc "Menu-bar Calendar sync app for maccal, bundling the maccal CLI"
  homepage "https://github.com/ikhoon/maccal"

  # The app self-updates in place via its "Check for Updates…" menu item, so the
  # installed version can move ahead of the cask between `brew upgrade`s.
  auto_updates true
  depends_on macos: :sonoma

  app "maccal.app"
  # Expose the CLI bundled inside the app on PATH, so `brew install --cask
  # maccal-app` gives you both the GUI app and the `maccal` terminal command.
  binary "#{appdir}/maccal.app/Contents/MacOS/maccal"

  # Self-signed (not notarized): strip the quarantine flag so Gatekeeper does
  # not block first launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/maccal.app"]
  end

  uninstall launchctl: "kr.ikhoon.maccal-sync",
            quit:      "kr.ikhoon.maccalbar"

  zap trash: [
    "~/Library/Application Support/maccal",
    "~/Library/LaunchAgents/kr.ikhoon.maccal-sync.plist",
    "~/Library/Preferences/kr.ikhoon.maccalbar.plist",
  ]
end
