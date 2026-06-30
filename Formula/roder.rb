class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.1.8.tar.gz"
  version "0.1.8"
  sha256 "aa26497a4c5343f3a3dabc3bf2064182668ca369888bca556ab47de58a26cdc5"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/roder-cli")
  end

  test do
    assert_match "codex:", shell_output("#{bin}/roder auth status")
  end
end
