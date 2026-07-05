# Homebrew formula for disco — a read-only Discord activity CLI.
#
# Binary tap: downloads the compiled binary from the GitHub release. (A source
# build isn't viable here — Homebrew's build sandbox blocks the network during
# `install`, so a bun toolchain fetch can't run. The prebuilt download also
# avoids Gatekeeper: Homebrew's curl doesn't set the com.apple.quarantine flag.)
class Disco < Formula
  desc "Discord activity CLI — read channels, threads, mentions, and search"
  homepage "https://github.com/ikhoon/disco"
  # version is explicit — else Homebrew mis-parses "64" from "arm64" in the
  # filename. Kept on bare lines: the release workflow rewrites version/url/
  # sha256 with sed.
  version "0.2.0"
  url "https://github.com/ikhoon/disco/releases/download/v0.2.0/disco-0.2.0-macos-arm64.zip"
  sha256 "e9d670b3a96ecd69fe61e91cedbf658ca8f0bcaa1258f4f2e78143c7feb3a11f"

  depends_on :macos
  depends_on arch: :arm64

  def install
    bin.install "disco"

    # The binary emits its own completion scripts (embedded at build time).
    (zsh_completion/"_disco").write Utils.safe_popen_read(bin/"disco", "completions", "--shell", "zsh")
    (bash_completion/"disco").write Utils.safe_popen_read(bin/"disco", "completions", "--shell", "bash")
  end

  def caveats
    <<~EOS
      disco needs a Discord token: set DISCORD_TOKEN, or store one in the macOS
      Keychain with `disco auth set` (see `disco --help` for how to get one).

      ⚠ Search/mentions/DMs require a *user* token, and automating a user
      account violates Discord's ToS — personal, read-only use at your own
      risk. A bot token (--bot) is the ToS-safe subset.
    EOS
  end

  test do
    assert_match "0.2.0", shell_output("#{bin}/disco --version")
  end
end
