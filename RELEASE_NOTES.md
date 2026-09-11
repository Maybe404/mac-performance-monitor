# Mac Performance Monitor 2.1.0

Build 236, 11 September 2026. For Apple silicon Macs running macOS 15 or later.

[Download the signed installer](https://github.com/Zesty0wl/mac-performance-monitor/releases/download/v2.1.0.236/MacPerformanceMonitor.pkg).
Existing installs can use **Check for Updates** to update through Sparkle.

## Energy In More Detail

All six Energy cards now open a larger chart with values and explanations:
Charge, Estimated runtime, Mac power draw, Battery temperature, Health, and
Cycles. Detail views are snapshots, so they stay still while you inspect them.
Their range controls work without changing the main page.

Health and Cycles have their own month and year ranges. Daily records keep
each battery pack separate and survive the usual 90-day history limit. They
still count toward the database size cap. Long-term trends grow from real
readings with history logging on; missing older data stays missing.

Runtime uses the macOS estimate first. If it is absent, the app can estimate
runtime after at least three minutes of steady discharge. Past estimates stay
as recorded. A separate dashed line forecasts charge at the same rate of use.
It is a forecast, not a promise or a real charge reading. While charging, the
card shows time to full instead.

Mac power draw and battery flow are distinct. Positive battery flow means
charging; negative flow means draining. Charge and runtime also offer
**Since unplugging** when the app saw the switch to battery power. Headings
and values fit narrow windows, and every card opens even without history.

## Accessory Batteries

Energy now shows the battery levels macOS reports for mice, keyboards,
AirPods, and other devices. Left, right, and case levels appear when known.
A charging icon appears only when macOS reports that state.

The app checks at most once a minute. macOS can return cached values, so a
report is not proof of a fresh reading. Missing values stay unknown, and a
failed check labels retained values as last reported.

Low accessory battery alerts are off by default. Turn them on in
**Settings > Alerts** and choose a level from 5% to 50%, with 20% as the default.
Two low reports confirm a warning. AirPods parts share one quiet notice,
which opens Energy. Notices wait for charge to recover before repeating.
With alerts on, checks continue while the app runs, even with Energy hidden.

## History Across Restarts

Process detail and Explorer charts can include earlier, non-overlapping
instances of the same program. A restart leaves a break in the line and in
disk-rate calculations. Concurrent instances are not added together.

The Dashboard now shows uptime beneath the machine details, with the boot
date on hover. It includes sleep and refreshes once a minute.

## Before You Upgrade

- Existing history and trace files remain readable. New fields cannot recover
  data that earlier versions did not store. Back up your data before a downgrade.

- Accessory reports use a macOS command whose output is not a public API.
  Bounded reads and defensive parsing handle missing or changed fields.
  Future macOS changes may still make these reports unavailable.

- Health, cycles, and runtime estimates do not predict a battery failure date.
  Runtime depends on workload, and long-term wear history starts with new readings.

- English, Simplified Chinese, German, and French have full string coverage.
  Generated translations still need review by native speakers.

Performance history stays on your Mac. Updates, signed content downloads, and
network tools use the network but do not upload that history.

Read the [full changelog](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.1.0.236/CHANGELOG.md)
and [Energy guide](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.1.0.236/docs/energy-design.md).
The [Explorer guide](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.1.0.236/docs/explorer-design.md)
and [security policy](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.1.0.236/SECURITY.md)
cover other features and data handling.