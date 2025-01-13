class I18nhero < Formula
  desc "CLI tool for interacting with locales hosted on i18nhero.com"
  homepage "https://i18nhero.com"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/i18nhero/cli/releases/download/v0.0.3/i18nhero-aarch64-apple-darwin.tar.gz"
      sha256 "cfff58917255216499c86ec05d09b163a65792d27c26f3327af72f24a0057ac1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/i18nhero/cli/releases/download/v0.0.3/i18nhero-x86_64-apple-darwin.tar.gz"
      sha256 "1a20892333bc28dedb568410649bc77cf838dc5408941ec8e48fcf31fad7ed9e"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/i18nhero/cli/releases/download/v0.0.3/i18nhero-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "68739cefca04c22d78ab14825d8b56de54d146a5e539ef8825c87557662cc54d"
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
