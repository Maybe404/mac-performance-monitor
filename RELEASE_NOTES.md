# Mac Performance Monitor 2.0.0

Build 231, 10 September 2026. For Apple silicon Macs running macOS 15 or later.

[Download the signed installer](https://github.com/Zesty0wl/mac-performance-monitor/releases/download/v2.0.0.231/MacPerformanceMonitor.pkg).
Existing installs can use **Check for Updates** to update through Sparkle.

## Explore What Happened

Explorer replaces the Analytics start screen. Inspect a moment in your Mac's
history, compare up to eight processes, and put machine and sensor charts on
the same timeline. Search for running or exited processes, pin a time, and read
the source values and timestamps in the inspector.

Use a chart grid, a list, or an expanded chart. Hold Command and scroll to zoom
around the pointer while ordinary scrolling still moves the page. Export the
visible source data as CSV or share process history in a trace file. Existing
trace imports remain supported.

## Alerts That Follow Change

Stable high swap usage alone no longer triggers an alert. Swap warnings use
continued growth or paging strain. A condition can escalate as it worsens,
without first dropping below yesterday's fixed threshold.

Process checks reject stale readings and growth that has settled. Modest
findings stay under Observations, not in the red alert count. A separate
fast-growth check can catch runaway use before the longer analysis is ready.
Growth is evidence to investigate, not proof of a memory leak.

Click the menu bar badge to see active alerts by process or machine. Open an
alert's evidence in Explorer, or snooze ordinary notices for one hour. Related
memory alerts share a notice. Only critical notices request sound, and incident
state survives an app restart.

## Clearer Charts And Controls

Dashboard and Explorer show a clear average over a translucent recorded range.
Short bursts stay visible, and missing readings remain gaps. Historical shapes
stay stable as new data arrives. Dashboard cards open larger, frozen detail
views with their values and explanations.

Energy charts now have hover details with the right units. Disk and network
menu panels keep their layout as readings change. This release also fixes a
crash during history maintenance, empty first-open detail sheets, and GPU
temperature discovery that could discard a sensor for the whole session.

## Run It Your Way

The menu bar item and history recorder have separate switches. Open the app
from the Dock, Spotlight, or Launchpad even with the menu bar item hidden.
The Dock icon follows the window, with an option to keep it visible. Login
launches stay quiet.

English, Simplified Chinese, German, and French have full string coverage.
Generated translations still need native review. Sparkle is updated to 2.9.6,
including fixes for the August 2026 security advisories.

## Before You Upgrade

- You still need Apple silicon and macOS 15 or later.

- Existing alert choices carry forward. The old fixed swap ceiling is no
  longer used. Explicit process-memory budgets remain a separate option.

- Existing history and trace files remain readable. New fields preserve more
  detail from new samples; they cannot reconstruct missing historical data.
  Back up the app's data before testing a downgrade.

- Alert checkpoints and delivery logs remain local and are separate from full
  history recording. They can retain evidence even with that recording off.

- Hardware inventory is a current snapshot, not a historical device list.
  Older chart data remains limited by the resolution that was retained.

- Use Quiet Evaluation to observe growth rules without growth notifications.
  Critical-pressure protection and explicit budgets keep their own settings.

Performance history stays on your Mac. Updates, signed content downloads, and
network tools use the network but do not upload that history. Review exports
and screenshots before sharing them.

See the [full changelog](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.0.0.231/CHANGELOG.md),
[Explorer guide](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.0.0.231/docs/explorer-design.md),
[alert policy](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.0.0.231/docs/adaptive-alerts.md),
and [security policy](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.0.0.231/SECURITY.md).