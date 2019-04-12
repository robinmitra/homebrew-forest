require "language/go"

class Forest < Formula
  desc "For the forest on your computer"
  homepage "https://github.com/robinmitra/forest"
  url "https://github.com/robinmitra/forest/archive/v0.2.0.tar.gz"
  sha256 "c19a5b03092ca520a2986fc8eb254f5deaac7d54e9ccfa226b12f1b75e415407"

  depends_on "go" => :build

  go_resource "github.com/sirupsen/logrus" do
    url "https://github.com/sirupsen/logrus.git",
        :revision => "9b3cdde74fbe9443d704467498a7dcb61a79de9b"
  end

  go_resource "github.com/gosuri/uilive" do
    url "https://github.com/gosuri/uilive.git",
        :revision => "ac356e6e42cd31fcef8e6aec13ae9ed6fe87713e"
  end

  go_resource "github.com/cheynewallace/tabby" do
    url "https://github.com/cheynewallace/tabby.git",
        :revision => "b7224f6123093cc04ce961170a360e1d22e214a5"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "67fc4837d267bc9bfd6e47f77783fcc3dffc68de"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "24fa6976df40757dce6aea913e7b81ade90530e1"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
        :revision => "f4905fbd45b6790792202848439271c74074bbfd"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
        :revision => "4b34438f7a67ee5f45cc6132e2bad873a20324e9"
  end

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath / "src/github.com/robinmitra/forest"
    # Copy all files from their current location (GOPATH root) to
    # $GOPATH/src/github.com/robinmitra/forest
    bin_path.install Dir["*"]

    ohai "Staging dependencies"

    # Stage dependencies. This requires the "require language/go" line above.
    Language::Go.stage_deps resources, buildpath / "src"

    ohai "Building Forest"

    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing# global variable
      system "go", "build", "-o", bin / "forest", "."
    end

    ohai "Done!"
  end

  test do
    # "2>&1" redirects standard error to stdout. The "2" at the end means "the
    # exit code should be 2".
    assert_match "forest 0.2.0", shell_output("#{bin}/forest version 2>&1", 0)
  end
end
