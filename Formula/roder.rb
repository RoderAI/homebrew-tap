class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/releases/download/roder%2Fv0.1.14/roder-aarch64-apple-darwin.tar.gz"
  version "0.1.14"
  sha256 "7dc0309d48f9bcdf08df775978c21b7a9b5446ee828bbbf9818f19c5f3b89b1c"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  option "with-source", "Build from source instead of installing the signed release binary"

  depends_on "rust" => :build if build.head? || build.with?("source")

  resource "source" do
    url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.1.14.tar.gz"
    sha256 "5d53b0fa97ce61cc937ca94de5884fddb12f9dc6bfcbb81864f84150c903515e"
  end

  def install
    if build.head?
      system "cargo", "install", *std_cargo_args(path: "crates/roder-cli")
    elsif build.with?("source")
      resource("source").stage { system "cargo", "install", *std_cargo_args(path: "crates/roder-cli") }
    else
      odie "Roder publishes signed macOS release binaries for Apple Silicon only; use --with-source for a local source build." unless OS.mac? && Hardware::CPU.arm?

      bin.install "roder-aarch64-apple-darwin/roder" => "roder"
    end
  end

  test do
    assert_match "codex:", shell_output("#{bin}/roder auth status")
  end
end
