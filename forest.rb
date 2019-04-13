class Forest < Formula
  desc "For the forest on your computer."
  homepage "https://github.com/robinmitra/forest"
  url "https://github.com/robinmitra/forest/archive/v0.2.2.tar.gz"
  sha256 "b251ddd5081ab5083cdcfc559179bdbee04250e8fc059cefc190c0f98909cf5b"

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    forest_path = buildpath / "src/github.com/robinmitra/forest"
    # Copy all files from their current location (i.e. GOPATH root) to `forest_path` (i.e.
    # $GOPATH/src/github.com/robinmitra/forest)
    forest_path.install Dir["*"]

    ohai "Building Forest"

    cd forest_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing# global variable
      system "go", "build", "-o", bin / "forest", "."
    end

    ohai "Done!"
  end

  test do
    # "2>&1" redirects standard error to stdout. The "2" at the end means "the
    # exit code should be 2".
    assert_match "forest 0.2.2", shell_output("#{bin}/forest version 2>&1")
  end
end
