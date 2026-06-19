# Homebrew formula for macmail — a fast, scriptable CLI for macOS Mail.app.
#
# Binary tap: downloads the codesigned .app from the GitHub release and links it.
# (A source build isn't viable here — Homebrew's build sandbox blocks the network
# during `install`, so `bun install` can't run. The prebuilt download also avoids
# Gatekeeper: Homebrew's curl doesn't set the com.apple.quarantine flag.)
class Macmail < Formula
  desc "Fast, scriptable CLI for macOS Mail.app — triage, search, read, reply"
  homepage "https://github.com/ikhoon/macmail"
  version "0.2.0"
  url "https://github.com/ikhoon/macmail/releases/download/v0.2.0/macmail-0.2.0-macos-arm64.zip"
  sha256 "9b10b9407a056be85359e5b3742831818eb6bc9887bb07a31a10c074c4f7ed57"

  depends_on :macos
  depends_on arch: :arm64

  def install
    prefix.install "macmail.app"
    (bin/"macmail").make_symlink prefix/"macmail.app/Contents/MacOS/macmail"

    # The binary emits its own completion scripts (no Full Disk Access needed).
    (zsh_completion/"_macmail").write Utils.safe_popen_read(bin/"macmail", "completions", "--shell", "zsh")
    (bash_completion/"macmail").write Utils.safe_popen_read(bin/"macmail", "completions", "--shell", "bash")
  end

  def caveats
    <<~EOS
      macmail reads ~/Library/Mail, so it needs Full Disk Access.
      Run a read command once (e.g. `macmail triage`), then turn on "macmail" in
        System Settings → Privacy & Security → Full Disk Access
      (it appears by name and icon). Once granted it works from any terminal.
    EOS
  end

  test do
    assert_match "0.2.0", shell_output("#{bin}/macmail --version")
  end
end
