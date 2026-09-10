# Homebrew Distribution

Users can install the latest published app without adding a tap:

```sh
brew install --cask mac-performance-monitor
```

The cask in this repository is
[Casks/mac-performance-monitor.rb](../Casks/mac-performance-monitor.rb).
Homebrew keeps its own copy. Check both when the version, install steps, or
supported Mac models change.

## Preparing 2.0

Keep the cask on the latest published package while 2.0 is in development.
Do not point its version or URL at a test build with no public download.
The final build number and hash must come from the published signed package.

Use the hash after signing, notarization, and stapling. Do not copy it from a
`--skip-upload` package: the later resume pass rebuilds those bytes. Follow the
[release checklist](release-checklist.md) for the source and tag checks.

## What The Cask Does

Homebrew uses a cask for a packaged app. Building from source is a different
path: it does not produce the signed release package or Apple's notary ticket.
The release includes the app, its helper, and Sparkle for updates.

- `pkg` installs the package from its release tag. The checksum pins that
  file. Keep the old `verified:` option out; Homebrew rejected it during the
  original review.

- `auto_updates true` tells Homebrew that Sparkle can update the app.
  A normal `brew upgrade` skips it; `--greedy` includes it.

- `depends_on` limits installs to Apple silicon and macOS 15 or later.

- `uninstall` stops the helper, quits the app, and forgets the package receipt.
  It does not erase the user's history.

- `zap` removes local app data. This includes history, settings, caches, and
  the new alert files in `~/Library/Application Support/MacPerformanceMonitor`.
  Treat this as data deletion, not routine cleanup after a test.

- The cask has no `livecheck` block. Homebrew's GitHub release strategy follows
  published releases. The four-part version is the app version plus its build
  number, for example `1.7.1.206`.

## Check An Update

Check style from the repository root:

```sh
brew style Casks/mac-performance-monitor.rb
```

For an audit, use a local test tap. The following commands create that tap and
copy the cask into it. The audit needs network access, but does not install the
app. Use a fresh tap name if `local/test` already exists.

```sh
brew tap-new local/test --no-git
cp Casks/mac-performance-monitor.rb "$(brew --repository)/Library/Taps/local/homebrew-test/Casks/"
brew audit --cask --online local/test/mac-performance-monitor
```

Test the package on a test Mac or with backed-up app data. These commands
install and remove the app; they are not read-only checks:

```sh
brew install --cask local/test/mac-performance-monitor
brew uninstall --cask local/test/mac-performance-monitor
brew untap local/test
```

## After Each Release

The publisher updates this repository's cask with the final version and hash.
That edit reaches tap users only after it is committed and pushed to the branch
the tap reads. Check the public download before pushing the change.

Homebrew's bot can open a version-bump PR when a release appears. Verify that
update instead of assuming it has merged. To request a bump by hand, use the
published four-part version in place of `X.Y.Z.B`:

```sh
brew bump-cask-pr mac-performance-monitor --version X.Y.Z.B
```

Changes to install rules, minimum macOS, or uninstall paths also need a PR in
Homebrew's copy. A version bump alone will not carry those edits across.

## This Repository's Tap

The separate tap remains available:

```sh
brew tap zesty0wl/mac-performance-monitor https://github.com/Zesty0wl/mac-performance-monitor
brew install --cask zesty0wl/mac-performance-monitor/mac-performance-monitor
```

Existing tap installs can still receive Sparkle updates. Users do not need to
reinstall just to change where Homebrew finds the cask.

## Original Submission

Homebrew accepted the cask on 3 September 2026 in
[PR #283646](https://github.com/Homebrew/homebrew-cask/pull/283646).
The repository had 239 stars, the cask name was free, and the package passed
the signing and install checks. These are facts about that submission, not
proof that a future package passes.

The original PR added `Casks/m/mac-performance-monitor.rb` to Homebrew's fork.
It used the title `mac-performance-monitor 1.5.0.198 (new cask)` and ran
`brew style` plus `brew audit --cask --online --new`. Future releases update
that existing cask, not submit a second new one.

The bot moved the cask to 1.7.0.205 about five hours after the first merge.
That was one observed update, not a promise about the next release.
