class Html2pdf < Formula
  desc "Convert HTML to PDF using a Headless Chrome browser"
  homepage "https://github.com/ilaborie/html2pdf"
  version "0.8.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.1/html2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "0d8c7faeed146da3034e379b24c2c7ef44e9d04eb5fb3ee796a083597bf614c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.1/html2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "c3a04514d87ac6171b22444c19229a1d85fbeb270de79daa509a7191f0cba6fa"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.1/html2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "25ce9baeefe4b1eab37c7bce71cfa5e36444e14256fd043bf3a59a201cce9a18"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.1/html2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "524c4aa5bbcb216b76188d617e55aeef6c0b475002b8479a8f55763a0b21c093"
    end
  end
  license any_of: ["Apache-2.0", "MIT"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
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
    bin.install "html2pdf" if OS.mac? && Hardware::CPU.arm?
    bin.install "html2pdf" if OS.mac? && Hardware::CPU.intel?
    bin.install "html2pdf" if OS.linux? && Hardware::CPU.arm?
    bin.install "html2pdf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
