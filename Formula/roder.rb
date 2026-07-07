class Roder < Formula
  desc "Rust-native TUI coding agent and event-driven agent harness"
  homepage "https://github.com/RoderAI/roder"
  url "https://github.com/RoderAI/roder/releases/download/roder%2Fv0.1.9/roder-aarch64-apple-darwin.tar.gz"
  version "0.1.9"
  sha256 "8d13e2e02a2c1cddab4a2498c32a15c762bf8dbf9e777b7aa3437a142d6fea69"
  head "https://github.com/RoderAI/roder.git", branch: "master"

  option "with-source", "Build from source instead of installing the signed release binary"

  depends_on "rust" => :build if build.head? || build.with?("source")

  resource "source" do
    url "https://github.com/RoderAI/roder/archive/refs/tags/roder/v0.1.9.tar.gz"
    sha256 "668616a425df2a441a05a303113eba224dbf5be7c01bd475ab1b2a9ade2f1823"
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
