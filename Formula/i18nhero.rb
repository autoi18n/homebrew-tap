class I18nhero < Formula
  desc "CLI tool for interacting with locales hosted on i18nhero.com"
  homepage "https://i18nhero.com"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/i18nhero/cli/releases/download/v0.0.2/i18nhero-aarch64-apple-darwin.tar.gz"
      sha256 "6980f489168e6e338594bdd9bbdfb69706eedb5f4fed0088449381aec7a546c7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/i18nhero/cli/releases/download/v0.0.2/i18nhero-x86_64-apple-darwin.tar.gz"
      sha256 "6065efcfc2ea34c276852c7ea0b12ffc8659fecebcf9277ddf54d927a8435a92"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/i18nhero/cli/releases/download/v0.0.2/i18nhero-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "6cf6722a991285d68330637b7474d2270cde3825db98bba8e06bf85fe806df5f"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "i18nhero" if OS.mac? && Hardware::CPU.arm?
    bin.install "i18nhero" if OS.mac? && Hardware::CPU.intel?
    bin.install "i18nhero" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
