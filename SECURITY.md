# Security Policy

Mac Performance Monitor reads process, memory, and device data. It keeps that
history and alert evidence on your Mac. It sends no usage telemetry, but it
does use the network. For example, it checks for updates and runs network tests.

## Reporting a vulnerability

Report security issues in private, not in a public issue.

- Use GitHub's private vulnerability reporting (the "Report a vulnerability"
  button under the repository's **Security** tab), or
- contact the maintainers at the address listed on the repository profile.

Tell us what went wrong, which version or commit you used, and how to repeat it.
We will confirm receipt, look into the issue, and keep you informed about a fix.
Please allow time for that work before making the report public.

## Supported versions

Fixes target the latest release and current development branches. Include the
version and build number when reporting an issue, plus the commit for a source
build. Older releases may not receive the same fixes.

## Privacy posture

- No usage telemetry or analytics. With recording on, the app stores full
  performance history in a local SQLite database.

- Alert state uses separate local files. They can hold process names, paths,
  IDs, and evidence even with full history off. See
  [Adaptive alerts](docs/adaptive-alerts.md#local-evidence) for the limits.

- CSV, traces, hardware reports, and screenshots can contain private details.
  Check them before sharing. Exports keep the original names and paths; they
  do not hide who or what the data describes.

- Sparkle checks for and downloads updates. The app also downloads signed
  checks and glossary content. Network tools contact the hosts or networks you
  choose. These features do not upload your recorded performance history.

- The app is not sandboxed. You can enable a privileged helper to read more
  processes. The app and helper check each other's code signatures.
  Full Disk Access lets disk scans and other tools read more files.

- Actions you choose can make changes. These include force-quitting a process,
  installing the helper, or applying an update. Routine monitoring is separate
  from those actions. Read prompts and check permissions before proceeding.

## Release Integrity

Published apps and packages use Developer ID signing and Apple notarization.
Sparkle also checks the update's EdDSA signature. A local or ad-hoc build does
not provide the same checks as a published package.

Keep signing keys, certificates, private settings, databases, and alert logs
out of git and security reports. Send only what we need to repeat the issue.
Remove unrelated paths and account details first.

