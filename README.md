# Homebrew tap for kbase

`kbase` builds a knowledge base from LaTeX and maintains it. The formula here builds it from source.

## Developer
<https://keyoxide.org/wkd/benn@bennherrera.dev>

## Install

```sh
brew tap benn-herrera/kbase
brew install kbase
```

The build needs Go, and the installed binary needs `git` to record a build's stage commits, `pandoc`
to parse LaTeX, and Graphviz `dot` to draw the claim-graph sheets. The formula depends on all four.

`brew install --HEAD kbase` builds the repository's `develop` branch instead of the tagged release.

## Development

`Formula/kbase.rb` is maintained beside the kbase source tree, which clones this repository into
`homebrew-kbase/` with `just tap`. That clone is not the copy `brew` reads: a tap lives under
`$(brew --repository)/Library/Taps/`. To exercise an edit before publishing it, point the tapped copy
at this working tree:

```sh
brew tap benn-herrera/kbase
ln -sf "$(pwd)/homebrew-kbase/Formula/kbase.rb" \
  "$(brew --repository)/Library/Taps/benn-herrera/homebrew-kbase/Formula/kbase.rb"
brew audit --strict --formula benn-herrera/kbase/kbase
brew reinstall --build-from-source kbase
```

## Releasing a new version

1. Tag the kbase source tree (`just dist --tag` does this after a complete dist build).
2. Point `url` at the new tag's source tarball.
3. Replace `sha256` with the value `brew fetch kbase` reports.
