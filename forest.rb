class Forest < Formula
  version '0.3.0'
  desc "For the forest on your computer."
  homepage "https://github.com/robinmitra/forest"
  url "https://github.com/robinmitra/forest/archive/v#{version}.tar.gz"
  sha256 "c4cedb0e32fc8534f183dab5f9a363f71daac162b2eee546ae231f9339324ac0"

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
    assert_match "forest #{version}", shell_output("#{bin}/forest version 2>&1", 0)
  end
end
