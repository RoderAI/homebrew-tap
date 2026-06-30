class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.1.7.tar.gz"
  version "0.1.7"
  sha256 "6f9cba8af250e5dc157f9e3d194fbefc90eb5dfec6574c75390f235f28bb2bce"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/roder-cli")
  end

  test do
    assert_match "codex:", shell_output("#{bin}/roder auth status")
  end
end
