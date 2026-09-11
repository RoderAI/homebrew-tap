class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/releases/download/roder%2Fv0.1.23/roder-aarch64-apple-darwin.tar.gz"
  version "0.1.23"
  sha256 "e5c85b60b264862c0a3ff421eead7d3db94d84dbf410bafc8bc0b3a61c23fd0c"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  option "with-source", "Build from source instead of installing the signed release binary"

  depends_on "rust" => :build if build.head? || build.with?("source")

  resource "source" do
    url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.1.23.tar.gz"
    sha256 "bc7615d7dd7881e6bab2397e46ef3d7db00f14d59246ca41c5920d5f56bfb9f9"
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
