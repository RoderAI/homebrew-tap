class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.1.6.tar.gz"
  version "0.1.6"
  sha256 "13546fe68115c5187b08b1e04749856c98f0cbe621e64a499463cc4fded395b5"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/roder-cli")
  end

  test do
    assert_match "codex:", shell_output("#{bin}/roder auth status")
  end
end
