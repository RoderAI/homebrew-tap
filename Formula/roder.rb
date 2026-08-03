class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/releases/download/roder%2Fv0.1.18/roder-aarch64-apple-darwin.tar.gz"
  version "0.1.18"
  sha256 "b0d4dceeaf456584300c13a0b1838a414be262e8d5be5f2985b16b182f8e6b97"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  option "with-source", "Build from source instead of installing the signed release binary"

  depends_on "rust" => :build if build.head? || build.with?("source")

  resource "source" do
    url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.1.18.tar.gz"
    sha256 "69140c50ddde09d4286e64c7a602619b3206770cd748886d3eb6a7cdc56a1eeb"
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
