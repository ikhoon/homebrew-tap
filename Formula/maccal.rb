# Homebrew formula for maccal — installed via the ikhoon/tap tap:
#   brew install ikhoon/tap/maccal
#
# The artifact is the universal (arm64 + x86_64) maccal.app produced by
# ./release.sh in the maccal repo and attached to the GitHub release. Installing
# through brew does not quarantine the download, so Gatekeeper does not block the
# ad-hoc-signed bundle (unlike a manual download from the release page).
#
# After bumping the version: in the maccal repo run ./release.sh and upload the
# zip to the GitHub release, then update `url` and `sha256` below.
class Maccal < Formula
  desc "Scriptable macOS Calendar CLI (EventKit) — agenda, search, add/edit/rm"
  homepage "https://github.com/ikhoon/maccal"
  url "https://github.com/ikhoon/maccal/releases/download/v0.11.1/maccal-v0.11.1-macos-universal.zip"
  sha256 "25cd6a0416967fe3d761c95f7ea39dc5f1a12ebe0ada9bf0ae83a9a1dc8401c3"

  depends_on :macos

  def install
    # Homebrew unpacks archives "nestedly": it strips leading single directories.
    # The zip is a single maccal.app whose only child is Contents/, so the strip
    # can leave the bundle at one of three depths — handle all of them.
    if File.directory?("maccal.app")
      prefix.install "maccal.app"
    elsif File.directory?("Contents")
      (prefix/"maccal.app").install "Contents"
    else
      (prefix/"maccal.app/Contents").install buildpath.children
    end
    bin.install_symlink prefix/"maccal.app/Contents/MacOS/maccal"
    generate_completions_from_executable(bin/"maccal", "completions",
                                         shells:                 [:zsh, :bash],
                                         shell_parameter_format: :arg)
  end

  def caveats
    <<~EOS
      maccal holds its own Calendar (TCC) permission via maccal.app —
      it does not grant your terminal calendar access. Authorize it once:
        maccal auth
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/maccal --version")
  end
end
