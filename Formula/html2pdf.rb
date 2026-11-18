class Html2pdf < Formula
  desc "Convert HTML to PDF using a Headless Chrome browser"
  homepage "https://github.com/ilaborie/html2pdf"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.10.1/html2pdf-aarch64-apple-darwin.tar.xz"
      sha256 "ad7b91bcb3f65ccf0cdd407356fc75014c1ae5da7fc5af5c46e16bdda616ac2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.10.1/html2pdf-x86_64-apple-darwin.tar.xz"
      sha256 "73cf008c119a9adf5e35ab773b4951b9cff424180d129c0063ed3cd2c09321da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.10.1/html2pdf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e0029f4a5a084ac8299dac33f7a6f90025baabdbe40b65982572608f42360b51"
    end
    if Hardware::CPU.intel?
      url "https://github.com/ilaborie/html2pdf/releases/download/v0.10.1/html2pdf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9470dcc34abc793ea32fec8941915900babf342110d7d244c0092c7d06c9d3fc"
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
