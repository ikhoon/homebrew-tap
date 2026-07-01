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
  url "https://github.com/ikhoon/macrec/releases/download/v1.0.0/macrec-1.0.0-macos-arm64.zip"
  sha256 "8e59009b801c31766acbffd863e5e06b90ced68918a3a5cabccfc528f6d3f815"

  depends_on arch: :arm64
  depends_on :macos

  def install
    prefix.install "macrec.app"
    # `macrec` CLI (config / engine / perm-status …); the same binary launches the menu-bar app.
    bin.install_symlink prefix/"macrec.app/Contents/MacOS/meeting-capture" => "macrec"
  end

  def caveats
    <<~EOS
      macrec is a menu-bar app. Launch it to start recording:
        open #{opt_prefix}/macrec.app        # (or) macrec <command>   e.g. macrec config

      Grant once in System Settings → Privacy & Security:
        • Screen & System Audio Recording   • Microphone   • Calendar
      Then enable "Start at login" in macrec's Settings for 24/7 recording.

      First run downloads the transcription model (~1.6 GB) to
        ~/Library/Application Support/MeetingRecorder/models/ (model is selectable in Settings).
      Transcripts + audio are written to the folders set in macrec's Settings.
    EOS
  end

  test do
    assert_match "suite=", shell_output("#{bin}/macrec config")
  end
end
