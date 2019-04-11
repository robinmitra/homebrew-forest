require "language/go"

class Forest < Formula
  desc "For the forest on your computer"
  homepage "https://github.com/robinmitra/forest"
  url "https://github.com/robinmitra/forest/archive/v0.1.1.tar.gz"
  sha256 "65884205a637f3a98b4ec84b6fce029b959bbe48bf3e3505c2cca9418d994d4f"

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

    bin_path = buildpath/"src/github.com/robinmitra/forest"
    # Copy all files from their current location (GOPATH root) to
    # $GOPATH/src/github.com/robinmitra/forest
    bin_path.install Dir["*"]

    # Stage dependencies. This requires the "require language/go" line above.
    Language::Go.stage_deps resources, buildpath/"src"

    cd bin_path do
      # Install the compiled binary into Homebrew's `bin` - a pre-existing# global variable
      system "go", "build", "-o", bin/"forest", "."
    end
  end

  test do

  end
end