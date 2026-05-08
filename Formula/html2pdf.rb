class Html2pdf < Formula
  desc "Convert HTML to PDF using a Headless Chrome browser"
  homepage "https://github.com/ilaborie/html2pdf"
  version "0.8.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.3/html2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "53b25ad8c38ab32c7f8578cd9bf5aa1a73dd3e8758c059dd9c04e0c40424bf23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.3/html2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "6b7a3cfddb12dc1fffaa160a3223750655400d525cffc7b49de9417cc8306336"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.3/html2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5a45475a1f6695c886ca0df08f975a63f794af9d9e48d09ab346598b9ad337b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.3/html2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8617015fd65a65cbf4ecd248635b06b8b27b2eb7fba5b9c758abfeb843336d42"
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
