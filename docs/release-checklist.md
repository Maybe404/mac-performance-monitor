# 2.0 Release Checklist

The maintainer approved publishing 2.0.0 from `main` on 10 September 2026.
Keep unfinished checks open until someone verifies them. Native translation
review remains a disclosed limitation, not a completed check.

## Source Status

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

- [ ] Commit and push the approved preparation changes, then get green hosted
  CI on that exact commit. The old failed run is not evidence of readiness.

- [ ] Rerun the local checks on the final release source if it changes.

- [ ] Review the 305 new `needs_review` entries in each of Simplified Chinese,
  German, and French with native speakers. Coverage is not native approval.

- [ ] Review every gallery image and translated compact view on the final app.
  The source catalog has full coverage, but generated wording still needs review.

Local verification on 10 September 2026 used Swift 6.3.3: 786 tests, two skips,
and no failures. The skips need a recorded database and a live hardware capture.
This verifies the preparation tree, not a future commit or signed installer.

## Local Checks

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

## Upgrade And Runtime Gates

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

## Publishing Hazards

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

## Approved Release Sequence

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

## Evidence To Retain

Record the final commit, build, tag, CI URL, test results and skips, upgrade/soak
notes, notarization results, and hashes of the published files. Keep private
keys, certificates, local histories, and incident logs out of the repository.
Do not publish with unresolved build, signature, tag, or feed failures.
Record manual checks not run and keep known limits visible in the release notes.