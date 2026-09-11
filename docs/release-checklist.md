# Release Checklist

## 2.1.0 Release

The maintainer approved publishing 2.1.0 from `main` on 11 September 2026.
The release build is 236; the prior public release is 2.0.0, build 231.
The draft downloads passed verification before the production feed changed.
The release became the latest stable version at 12:31:46 UTC on 11 September 2026.

### Source And Build

- [x] Start from clean `main` at `c413b5d`. Hosted CI run `34594914002`
  passed all gates. The local suite ran 849 tests with two skips and no failures.

- [x] Finalize the 2.1.0 changelog, release notes, README, and documentation index.
  Keep native translation review and missing older battery data limits visible.

- [x] Confirm Apple signing and notary access. Keep the existing Sparkle key
  and feed URL. Never generate a replacement key during a release.

- [x] Build and sign 2.1.0 build 236 with `Scripts/install.sh --no-launch`.
  The locked Mac blocked keychain access. After unlock, notarization resumed
  with the same signed bytes, without a rebuild or another build increment.

- [x] Package with `Scripts/deploy.sh --resume --skip-upload`.
  App, helper, installer, notarization, staples, and Gatekeeper checks pass.

- [x] Embed the release notes in the appcast. Verify the archive signature with
  the public key from the shipped 2.0.0 bundle. Archive size, version, download
  URL, minimum macOS 15.0, arm64 requirement, and embedded notes match.

- [x] Extract both artifacts. All files and symlinks match the signed source
  and installed app. All 2,499 catalog keys resolve in all four language bundles.

- [x] Test an upgrade from a populated v18 database. Old charge and temperature
  survive the new migrations; missing Energy values remain unknown. The full
  local suite passes 850 tests with two skips, plus formatting and both
  localization checks. The release build compiles the String Catalog.

- [x] Install the verified bundle and launch it. The helper is running and
  Energy draws live readings, retained charts, and accessory batteries. A
  private history backup passes SQLite integrity checks. This is a smoke test,
  not an end-to-end Sparkle UI upgrade or an extended soak.

- [x] Push the final source and build metadata at
  `3922772545fa38d1325f73efd218c393f2b654ff`. The worktree was clean and
  [release CI](https://github.com/Zesty0wl/mac-performance-monitor/actions/runs/34598750928)
  passed every gate in 5m40s on that exact commit.

### Publication

- [x] Create the annotated tag `v2.1.0.236` at the verified commit above.
  The remote tag resolves to that commit; no old tag moved.

- [x] Create a draft with that tag and the signed ZIP, package, and feed.
  Downloaded draft assets match the local files byte-for-byte. The downloaded
  ZIP passes Ed25519 verification with the public key from 2.0.0.

- [x] Publish [2.1.0 build 236](https://github.com/Zesty0wl/mac-performance-monitor/releases/tag/v2.1.0.236)
  as the latest stable release. The public installer, archive, and latest feed
  return HTTP 200 and match the verified files. The feed names build 236,
  keeps the macOS 15 and arm64 limits, and includes the release notes.

- [x] Update the repository cask with the exact public package checksum.
  Ruby syntax, checksum comparison, and Homebrew style checks pass.
  Homebrew's separate public cask can lag this update; it does not control Sparkle.

### Manual Coverage

Native translation review, a fresh end-to-end Sparkle UI update from 2.0.0,
and an extended workload soak remain separate from automated checks. Do not
claim them from unit tests or a short launch check. Runtime estimates still
need checks across real workloads. Synthetic daily data is not a year-long soak.

### Verified Artifacts

Apple accepted the app submission `4718bd42-2410-4100-9245-926cff280076`
and the package submission `473b14b1-bd46-4244-96f7-a52cfe359022`.
Both use Apple team `8352865GK4`. The existing Sparkle key is unchanged.
These hashes match the local artifacts, draft downloads, and public downloads:

```text
MacPerformanceMonitor.pkg
04e88fb0a8269495f9bbd51ecc1f7c2363fcec47d4912c8e05798165c3af9ea1

MacPerformanceMonitor-2.1.0.236.zip
b3a77e2a703e39af05ec2a44a8386dbced023578862878f6a30e93f4052f6f24

appcast.xml
4c69659aeb341e68e620c4c5cfb0fc81e51ca5f10dedc76966b9bd3575a2cf36
```

## 2.0 Release Record

The maintainer approved publishing 2.0.0 from `main` on 10 September 2026.
Keep unfinished checks open until someone verifies them. Native translation
review remains a disclosed limitation, not a completed check.

### Source Status

Preparation began on `2.0.0` at `c3508bc`, version 2.0.0, build 230.
The preceding public release is 1.7.1, build 206. The final release build and
verification results will be recorded below. Keep the cask on a public package.

- [x] Review the root README, changelog, contributor, security, and translation guides.

- [x] Prepare [release notes](../RELEASE_NOTES.md) and a [documentation index](README.md).

- [x] Keep the real Explorer and Dashboard screenshots from the running app.

- [x] Identify the [hosted CI failure](https://github.com/Zesty0wl/mac-performance-monitor/actions/runs/34489995543)
  at `c3508bc`: a cyclic-growth test fixture exceeded the Swift type-checking
  budget. Split it into typed intermediate values; its tests and lint pass locally.

- [x] Run the local build, full test suite, strict formatting, both string
  coverage checks, and String Catalog compilation on the preparation tree.

- [x] Audit all 436 keys added since 1.7.1. All four languages have values.
  Verify all 2,437 catalog keys through each compiled language bundle and
  correct the French Explorer capacity warning. See the
  [translation audit](../TRANSLATING.md#coverage-audit-10-september-2026).

- [x] Commit the preparation changes and fast-forward `main` to `8a8155a`.
  [Hosted CI](https://github.com/Zesty0wl/mac-performance-monitor/actions/runs/34502106577)
  passed build, tests, lint, source coverage, catalog compilation, and compiler
  string coverage on that commit.

- [x] Push build 231 metadata at `86a77f82e67b23ab2fa27644ec31dce546376a10`.
  [Final release CI](https://github.com/Zesty0wl/mac-performance-monitor/actions/runs/34503581438)
  passed every gate on that exact commit.

- [ ] Review the 305 new `needs_review` entries in each of Simplified Chinese,
  German, and French with native speakers. Coverage is not native approval.

- [ ] Review every gallery image and translated compact view on the final app.
  The source catalog has full coverage, but generated wording still needs review.

Local verification on 10 September 2026 used Swift 6.3.3: 786 tests, two skips,
and no failures. The skips need a recorded database and a live hardware capture.
This verifies the preparation tree, not a future commit or signed installer.

### Build 231 Checks

- [x] Build 2.0.0, build 231 from `main` without a marketing-version bump.
  The app and helper share the expected Apple team identity.

- [x] Apple accepted the app for notarization: `30fd89eb-bb15-4386-9d1a-d86b59b5acbf`.
  The installed copy passes signature, stapling, and Gatekeeper checks.

- [x] Apple accepted the package: `4061e2ff-2c8f-47df-b2e2-3bdbcdec2f72`.
  The installer signature, staple, and Gatekeeper checks pass.

- [x] The installed app opens its window and draws Dashboard history and live
  readings. The helper is running. This is a launch check, not a full soak.

- [x] The Sparkle ZIP signature verifies against the public key shipped in
  1.7.1. The feed advances build 206 to 231, keeps macOS 15 and arm64 limits,
  and names the exact versioned archive with its correct byte count.

- [x] Verify the draft downloads byte-for-byte, publish, and check all three
  public asset URLs. The latest installer and appcast, plus the versioned ZIP,
  return HTTP 200 and match the verified files.

Native translation review, a fresh end-to-end 1.7.1 update, and a new extended
soak remain unverified in this release pass. Earlier automated regression and
fixture checks do not replace those manual checks.

### Published Release

[2.0.0 build 231](https://github.com/Zesty0wl/mac-performance-monitor/releases/tag/v2.0.0.231)
was published as the latest stable release on 10 September 2026 at 16:45 UTC.
The annotated tag `v2.0.0.231` points to the tested release commit above.
The appcast embeds the release notes and uses the existing Sparkle signing key.

Both the installer and ZIP contain the same signed app. All 2,437 catalog keys
resolve from all four languages in each extracted bundle. The following hashes
match the unauthenticated public downloads:

```text
MacPerformanceMonitor.pkg
746eee1508474c775bc98934f18592c58947de7a68ec30d2c98d703fffd2c63c

MacPerformanceMonitor-2.0.0.231.zip
a9af4faa58b7c91cadb29ddf4663c12384f001123ba54e38402058ef66a1fd69

appcast.xml
2904d4cebd9990c7bb5b2eecb2a94ab4e3a16059ee25dc7d6492015374ea4a11
```

The repository's cask now uses that published package hash. Homebrew's separate
public cask can lag the release; its update is not part of the Sparkle rollout.

### Local Checks

Run from the repository root. These commands do not publish, sign, or install:

```sh
swift build
swift test
swift format lint --strict --recursive Sources Tests Package.swift
Scripts/check-localization.py
Scripts/check-string-coverage.py
xcrun xcstringstool compile Localizations/Localizable.xcstrings --output-directory /tmp/macperf-release-localizations
git diff --check
```

Inspect the test summary, including skips. The existing-database alert replay
is opt-in and read-only; see [Adaptive alerts](adaptive-alerts.md#verification).
It does not prove the new paging-strain rule matches real workloads, because
old history did not record those rates. Keep a longer live alert soak on the
release gate list.

Validate Markdown links and image references too. Check badge and download
links against the branch or release that readers will actually open.

### Upgrade And Runtime Gates

- [ ] Test an upgrade from the published 1.7.1 package with a backup of its data.
  Verify retained history and new schema fields without inventing old values.

- [ ] Verify an ordinary launch opens the window and a login launch stays quiet.
  Check independent menu bar, history, and Dock settings, including old mode migration.

- [ ] Verify helper authorization, app/helper identity checks, and full coverage
  on the final signed bundle. Ad-hoc tests do not cover this.

- [ ] Exercise Explorer with one and eight processes, exact-time navigation,
  Command-scroll, old history, missing data, CSV, and trace import/export.

- [ ] Exercise alerts with stable high swap, rapid growth and escalation,
  settling, sleep/wake, restart, recording off, snooze, and Quiet Evaluation.
  Confirm critical-pressure protection and notification permissions.

- [ ] Check light/dark appearance and all four languages, especially menus,
  evidence labels, first-open sheets, and long process names.

- [ ] Check disk and network menus, GPU and thermal readings, Disk Map,
  hardware inventory, and the process inspector on supported hardware.

- [ ] Run an extended signed-app session for CPU, memory, history size, and
  alert noise. Record the duration and workload rather than declaring a soak
  from a short unit test.

### Publishing Hazards

Read [deploy.sh](../Scripts/deploy.sh) before running it. Its default mode bumps
the patch version. From this branch, plain `Scripts/deploy.sh` would produce
2.0.1; `--major` would produce 3.0.0. Neither is the intended 2.0.0 release.

Use the existing no-bump path: build the already-versioned source with
`install.sh --no-launch`, then package with `deploy.sh --resume`. The install
step increments the build number and installs the signed app. It is not a
read-only check. `--skip-upload` avoids GitHub publication but still packages,
signs, and notarizes; it is not an offline dry run.

The publisher creates a release without `--target` or a notes file. If the tag
does not exist, GitHub can create it from the default branch, not the branch
whose app was built. Resolve this before publication: explicitly create the
tag at the verified release commit, or update and test the publisher to pin
that commit. Never move an already-published tag to repair an incorrect build.

The publisher also replaces assets if a release already exists. A retry must
reuse the intended source and build. Do not overwrite a released build with
different bytes without a deliberate release decision.

Keep the existing Sparkle EdDSA signing key. A replacement key would break
updates for installed apps. Recover the original key if it is missing; do not
generate a new one as part of this release.

### Approved Release Sequence

Use a draft release so the production feed stays unchanged until the uploaded
assets have been checked. This path publishes the exact verified package;
it does not rebuild the package between checking its hash and uploading it.

1. Choose the final source commit and publishing branch. If merging into `main`,
   get CI green there before building. Keep the same source through packaging.

2. Finalize the release notes and changelog date. Remove their draft notices.
   Update the README and security policy's pre-release wording. Check the CI
   badge and source-build branch if the documentation moves to `main`.

3. Build the existing 2.0.0 version, without a marketing-version bump:

   ```sh
   Scripts/install.sh --no-launch
   Scripts/deploy.sh --resume --skip-upload
   ```

   Both commands use signing credentials and Apple notarization. If a prompt
   needs a password, enter it directly in your terminal. Never put it in chat.

Convert the release notes to an HTML fragment beside the ZIP, using the same
filename stem. Regenerate the appcast with `--embed-release-notes` and the
existing key. Check the embedded text and signature before uploading the feed.

4. Verify source/app version and build parity, signatures, notarization, and stapling. Run the smoke tests above and record any manual checks not run. Use full URLs in the release notes. Commit and push the source, notes, and build metadata, then verify CI on that commit. Keep the worktree clean and HEAD equal to upstream.

5. Pin a new tag to that verified commit. Confirm the tag does not already exist
   locally or remotely. The following commands publish a tag and are not a check:

   ```sh
   release_commit="$(git rev-parse HEAD)"
   release_build="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' Resources/Info.plist)"
   release_tag="v2.0.0.${release_build}"
   git tag -a "$release_tag" "$release_commit" -m "Mac Performance Monitor 2.0.0 (build ${release_build})"
   git push origin "$release_tag"
   ```

6. Create a new draft release at that tag with `gh release create --draft --verify-tag --target "$release_commit" --notes-file RELEASE_NOTES.md`. Attach the signed ZIP, package, and appcast from step 3. Do not overwrite an existing release.

7. Download the draft assets and verify their hashes and Sparkle signature. Check the appcast version, minimum macOS, archive URL, and archive size. Publish with `gh release edit "$release_tag" --draft=false --latest` only after those checks pass. Then check the public latest-release download URLs.

8. Update the local cask version and checksum from that exact published package, then commit and push it to `main`. This draft workflow bypasses the publisher's automatic cask edit. Check Homebrew's separate public cask update; its timing is not guaranteed.

### Evidence To Retain

Record the final commit, build, tag, CI URL, test results and skips, upgrade/soak
notes, notarization results, and hashes of the published files. Keep private
keys, certificates, local histories, and incident logs out of the repository.
Do not publish with unresolved build, signature, tag, or feed failures.
Record manual checks not run and keep known limits visible in the release notes.