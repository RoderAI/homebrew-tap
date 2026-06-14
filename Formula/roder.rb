class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://static.crates.io/crates/roder/roder-0.1.0.crate"
  sha256 "9775a0e807f084e92f897488daf66a3fe492255157d131af59c5dc276e727ea6"
  license "MIT"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/roder --help")
  end
end
