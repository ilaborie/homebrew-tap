class Html2pdf < Formula
  desc "Convert HTML to PDF using a Headless Chrome browser"
  homepage "https://github.com/ilaborie/html2pdf"
  version "0.8.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.2/html2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "e1fe9c9af9f47a305a7ee85a29dc34f3d4613b88af87a79cda238d4071ea72bf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.2/html2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "db264ebe4561c198ef8d66fd7bd7075c1831ec20cb446ed0843caeca773a05f6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.2/html2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e344af96fbc3d705ad4abcbb9a45bd177ed46648f25b8a4ddb292ac1df0ee0db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.8.2/html2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9df9b84bf190887460cf22cece3e7b3702ef3fe72ca6c4e6bb9c09c5c533315b"
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
