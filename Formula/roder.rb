class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/releases/download/roder%2Fv0.3.4/roder-aarch64-apple-darwin.tar.gz"
  version "0.3.4"
  sha256 "941aa5a53b59264d2f31c5983ce4982d23cdadeb79dc197a66e3a1677f276210"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  option "with-source", "Build from source instead of installing the signed release binary"

  depends_on "rust" => :build if build.head? || build.with?("source")

  resource "source" do
    url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.3.4.tar.gz"
    sha256 "c650a559a6827a23b4ae73f4debfca044b3ecd7a88a17f46dc632ed85d6f01df"
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args(path: "crates/roder-cli")
    elsif build.with?("source")
      resource("source").stage { system "cargo", "install", *std_cargo_args(path: "crates/roder-cli") }
    else
      odie "Roder publishes signed macOS release binaries for Apple Silicon only; use --with-source for a local source build." unless OS.mac? && Hardware::CPU.arm?

      # Homebrew stages single-directory release archives in-place, so the
      # binary is available as ./roder rather than ./roder-<triple>/roder.
      bin.install "roder"
    end
  end

  test do
    assert_match "codex:", shell_output("#{bin}/roder auth status")
  end
end
