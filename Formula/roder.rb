class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/releases/download/roder%2Fv0.3.12/roder-aarch64-apple-darwin.tar.gz"
  version "0.3.12"
  sha256 "9e2ede05a387d2e945651cc82e8416d5dca84a4984923c4fde7124dfef51ab8d"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  option "with-source", "Build from source instead of installing the signed release binary"

  depends_on "rust" => :build if build.head? || build.with?("source")

  resource "source" do
    url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.3.12.tar.gz"
    sha256 "2d0f8d2536ac518bea9a248621321b55fe81720efbd02bc9d58a0c39418ffa21"
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
