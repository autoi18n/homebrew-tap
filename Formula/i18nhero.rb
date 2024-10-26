class I18nhero < Formula
  desc "CLI tool for interacting with locales hosted on i18nhero.com"
  homepage "https://i18nhero.com"
  version "0.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/i18nhero/cli/releases/download/v0.0.0/i18nhero-aarch64-apple-darwin.tar.gz"
      sha256 "2ad6263e172d6d9b152accba74945d7f90c2ef1d767d9022113d0138d98f49e1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/i18nhero/cli/releases/download/v0.0.0/i18nhero-x86_64-apple-darwin.tar.gz"
      sha256 "c5380c2a596cc4deee8ce773867a654b31ef377243d9247fab8c3125df93f2c4"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/i18nhero/cli/releases/download/v0.0.0/i18nhero-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "2848b0bab6bec96787a708b3327b9a0c23c536f581d9eaf151511324b53db60e"
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
