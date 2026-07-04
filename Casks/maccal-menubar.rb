# Homebrew cask for the maccal menu-bar app — installed via the ikhoon/tap tap:
#   brew install --cask ikhoon/tap/maccal-menubar
#
# The artifact is the universal maccal.app produced by ./package.sh in the maccal
# repo (it bundles the maccal CLI, so background sync needs no separate formula).
# After bumping the version: run ./package.sh, upload the menubar zip to the
# GitHub release, then update `version` and `sha256` below.
cask "maccal-menubar" do
  version "0.8.0"
  sha256 "a7e213986354d1b1a2cfef8c99f6c084600a57c0c986f0571a19d0d398022349"

  url "https://github.com/ikhoon/maccal/releases/download/v#{version}/maccal-menubar-v#{version}-macos-universal.zip"
  name "maccal menu-bar"
  desc "Menu-bar companion for maccal — scheduled background Calendar sync"
  homepage "https://github.com/ikhoon/maccal"

  depends_on macos: ">= :sonoma"

  app "maccal.app"

  # Ad-hoc signed (not notarized): strip the quarantine flag so Gatekeeper does
  # not block first launch. (brew's own download is not quarantined, but be
  # explicit in case the zip was fetched another way.)
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
