class Kbase < Formula
  desc "Build and maintain a knowledge base from LaTeX"
  homepage "https://github.com/benn-herrera/kbase"
  # Stable names the newest TAGGED release: v0.8.2 is built but not tagged, so
  # the source tarball for it does not exist yet. Move this tag when it does.
  url "https://github.com/benn-herrera/kbase/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "e5722075b4f535d98596fdd81a2b384b40dad775ecb982b4536086bc96f70335"
  license "MIT"
  head "https://github.com/benn-herrera/kbase.git", branch: "develop"

  depends_on "go" => :build
  # pandoc is not a core formula, so the fully qualified name taps jguer/pandoc.
  depends_on "jguer/homebrew-pandoc/pandoc"
  # Every stage of a build commits its boundary through git, so a KB needs the
  # repository's own git. pandoc parses the LaTeX, and dot draws the sheets.
  depends_on "git"
  depends_on "graphviz"

  def install
    # The dist tarball's build flag: `-tags=kbasedist` compiles out the
    # development replays (`score --replay`, `build --replay`), which a user
    # should not receive. std_go_args supplies `-trimpath`, the `-s -w` strip
    # and `-o=bin/kbase` itself.
    system "go", "build", *std_go_args(tags: "kbasedist"), "./cmd"
    bin.install "kbase"
  end

  # `kbase --version` prints exactly internal/version's Current, which is a bare
  # semver. A stable install was built from the tag the formula names, so the
  # two agree; a HEAD install is some other commit and may carry a version the
  # formula does not name.
  test do
    reported = shell_output("#{bin}/kbase --version").strip
    assert_match(/\A\d+\.\d+\.\d+\z/, reported)
    assert_equal version.to_s, reported if active_spec_sym == :stable
  end
end
