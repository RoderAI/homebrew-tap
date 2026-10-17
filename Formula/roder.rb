class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/releases/download/roder%2Fv0.3.15/roder-aarch64-apple-darwin.tar.gz"
  version "0.3.15"
  sha256 "061bf3ec2885a64661c7c5ac1547378c04ba705ab170a79b0c0a02a679bc24f3"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  option "with-source", "Build from source instead of installing the signed release binary"

  depends_on "rust" => :build if build.head? || build.with?("source")

  resource "source" do
    url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.3.15.tar.gz"
    sha256 "7b0423baec17a33e9749c0a461ec2809c89de07b81b2718656add9d2db80f0cc"
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
