# Homebrew formula for macrec — installed via the ikhoon/tap tap:
#   brew install ikhoon/tap/macrec
#
# The artifact is the self-contained, self-signed macrec.app produced by ./package.sh in the
# macrec repo and attached to the GitHub release. It bundles a static whisper-cli (Metal) + the
# silero VAD model; the large transcription model downloads on first run. Installing through brew
# does not set com.apple.quarantine, so Gatekeeper does not block the self-signed bundle (unlike a
# manual download from the release page).
#
# After a new release: run ./package.sh, upload dist/macrec.zip to the GitHub release as
# macrec-<version>-macos-arm64.zip, then update `url` and `sha256` below.
class Macrec < Formula
  desc "Always-on macOS meeting recorder with local whisper.cpp transcription"
  homepage "https://github.com/ikhoon/macrec"
  url "https://github.com/ikhoon/macrec/releases/download/v1.0.1/macrec-1.0.1-macos-arm64.zip"
  version "1.0.1"   # explicit — else Homebrew mis-parses "64" from "arm64" in the filename
  sha256 "6296ec5fd821cc4cf793fc9fa2dca512e240b05d4c344c5fd2181c8799ef75b1"

  depends_on arch: :arm64
  depends_on :macos

  def install
    # Homebrew strips leading single directories when unpacking; the zip is a single macrec.app
    # whose only child is Contents/, so the bundle can land at one of three depths — handle all.
    if File.directory?("macrec.app")
      prefix.install "macrec.app"
    elsif File.directory?("Contents")
      (prefix/"macrec.app").install "Contents"
    else
      (prefix/"macrec.app/Contents").install buildpath.children
    end
    # `macrec` CLI (config / engine / perm-status …); the same binary launches the menu-bar app.
    bin.install_symlink prefix/"macrec.app/Contents/MacOS/macrec"
  end

  def caveats
    <<~EOS
      macrec is a menu-bar app. Launch it to start recording:
        open #{opt_prefix}/macrec.app        # (or) macrec <command>   e.g. macrec config

      On first launch macrec requests these inline (click Allow):
        • System Audio Recording Only   • Microphone   • Calendar
      Then enable "Start at login" in macrec's Settings for 24/7 recording.

      First run downloads the transcription model (~1.6 GB) to
        ~/Library/Application Support/macrec/models/ (model is selectable in Settings).
      Transcripts + audio are written to the folders set in macrec's Settings.
    EOS
  end

  test do
    assert_match "suite=", shell_output("#{bin}/macrec config")
  end
end
