class Html2pdf < Formula
  desc "Convert HTML to PDF using a Headless Chrome browser"
  homepage "https://github.com/ilaborie/html2pdf"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.9.0/html2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "c4e9e642773a0e71fa2ecc5c920d435ce0fcb20300d1283e2a843abdf3615d6b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.9.0/html2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "a47df984a07f0621e2412ae3d599a1e85111e7a8d374ef286909b7b4cd8b8c72"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.9.0/html2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "94260b1e49ea4a305da41545572af0f381103082252c21e6fb88556ede413020"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.9.0/html2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "06bcce3165f937f2ad198398a75376449102d5b2a669295ad508d565f220fd9d"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "html2pdf"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "html2pdf"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "html2pdf"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "html2pdf"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
