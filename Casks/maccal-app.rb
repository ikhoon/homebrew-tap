# Homebrew cask for maccal — the menu-bar app *and* the maccal CLI:
#   brew install --cask ikhoon/tap/maccal-app
#
# Installs maccal.app (which bundles the maccal CLI) and exposes that CLI on your
# PATH, so one command gives you both the GUI sync app and the `maccal` terminal
# command. If you only want the CLI (no app), use the formula instead:
#   brew install ikhoon/tap/maccal
# Both provide `maccal` on PATH, so install one or the other — not both.
cask "maccal-app" do
  version "0.8.0"
  sha256 "a7e213986354d1b1a2cfef8c99f6c084600a57c0c986f0571a19d0d398022349"

  url "https://github.com/ikhoon/maccal/releases/download/v#{version}/maccal-menubar-v#{version}-macos-universal.zip"
  name "maccal"
  desc "Menu-bar Calendar sync app for maccal, bundling the maccal CLI"
  homepage "https://github.com/ikhoon/maccal"

  depends_on macos: :sonoma

  app "maccal.app"
  # Expose the CLI bundled inside the app on PATH, so `brew install --cask
  # maccal-app` gives you both the GUI app and the `maccal` terminal command.
  binary "#{appdir}/maccal.app/Contents/MacOS/maccal"

  # Ad-hoc signed (not notarized): strip the quarantine flag so Gatekeeper does
  # not block first launch.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/maccal.app"]
  end

  uninstall quit:      "kr.ikhoon.maccalbar",
            launchctl: "kr.ikhoon.maccal-sync"

  zap trash: [
    "~/Library/Application Support/maccal",
    "~/Library/Preferences/kr.ikhoon.maccalbar.plist",
    "~/Library/LaunchAgents/kr.ikhoon.maccal-sync.plist",
  ]
end
