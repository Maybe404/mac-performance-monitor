# Mac Performance Monitor 2.2.0

Build 260, 20 September 2026. For Apple silicon Macs running macOS 15 or later.
This update includes changes since 2.1.0, build 236.

[Download the signed installer](https://github.com/Zesty0wl/mac-performance-monitor/releases/download/v2.2.0.260/MacPerformanceMonitor.pkg).
Existing installs can use **Check for Updates** through Sparkle. Homebrew uses
the same installer; its cask update may arrive after this release.

## GPU And Neural Engine

The GPU tab now charts **Total, Reads, and Writes** on one bandwidth timeline.
It follows the same time range as utilization, with hover values and recorded
bounds. The chart is marked **Preview**: it estimates GB/s from bandwidth
buckets reported by macOS. Actual traffic can be higher. One quiet caption
explains this limit, instead of repeating a warning under each value.

**ANE Time** shows Neural Engine work that macOS accounts for, in milliseconds
per second. It needs macOS 27 and available counters. It is not a percent of
compute capacity and cannot reliably attribute shared services to one app.

**ANE Power** is a separate estimate in watts from Apple's powermetrics. It
needs the approved Full Coverage helper; ANE Time does not. Both have their
own cards and charts, plus a 60-second view in the GPU menu. Missing readings
stay unavailable, not zero.

**GPU awake** replaces the old Active label. It means time powered and clocked,
including waits, not time spent doing work. GPU Memory and GPU awake now have
recorded detail charts. Clock-state bars remain on the right with clearer help.

## Ask About This Mac (Preview)

Open **Ask** from the toolbar, app menu, or menu bar. Current reports work
without AI. To ask questions and generate explanations, enable the separate
choices in Ask settings.

With your consent, the local model can request up to four read-only checks of
recorded performance data from the past seven days. It cites the readings,
states uncertainty, and suggests a next check. It cannot run commands, delete
files, or change settings. Closing Ask clears the conversation.

Apple's on-device model is the default. It needs macOS 26.4 or later, supported
hardware, and Apple Intelligence enabled. Optional downloads offer other local
models:

| Model | Approximate Download | Status |
| --- | --- | --- |
| Qwen3 4B | 2.3 GB | Optional |
| Qwen3.5 4B | 3.1 GB | Experimental |
| DeepAnalyze 8B | 5.0 GB | Experimental; higher memory use |

Downloaded models need at least 16 GiB RAM and normal memory pressure. Each has
its own download and removal controls. The two experimental choices need an
explicit Download action. The original Qwen can download when you select it
with explanations enabled. No model weights ship inside the app.

Ask explains why a model is paused or an answer was rejected. Measured reports
remain available. Model choices stay explicit, with no silent switch to another
model or cloud service. Generated answers can still be wrong, even when their
citations pass checks. The new experimental models still need real-model tests.

Preview Siri and Shortcuts actions can open Ask or share current reports.
Sharing has separate consent. Apple controls Siri processing; Shortcuts can
send results to other actions, so do not assume that path stays on this Mac.

## Process Usage Timeline

Right-click a process and choose **Usage Timeline** to see when the recorder
observed it running. This is sampled process history, not proof of foreground
use or attention.

Optional Apple app and media activity appears in separate lanes. It needs Full
Disk Access and a per-window opt-in. Device and foreground status are not
verified. These optional records stay in memory and are not added to the app's
performance database.

## Ranges And Fixes

History views start at 30 minutes when no range is saved. Each view remembers
its own choice across tab changes and restarts. Explorer keeps your chosen zoom
span without replacing it when you open an alert.

Missing GPU OFF-state readings no longer appear as 100% awake. The main-window
toolbar also stays mounted while content loads or the window reopens.

## Before You Upgrade

- New GPU history grows from new recordings. Older logs cannot supply bandwidth,
  GPU memory, awake time, or ANE readings they never stored. Keep recording on
  to build these charts, and back up your data before testing a downgrade.

- GPU and Neural Engine counters vary with hardware and macOS. The bandwidth
  preview is approximate, and power is not a measure of utilization.

- Local AI can stop under memory or thermal pressure, even on an eligible Mac.
  Ask is a preview, not a verified diagnosis. Check its cited evidence.

- English, Simplified Chinese, German, and French have full string coverage.
  New generated translations still need native review. Broader Siri/Shortcuts,
  model, and workload testing remains incomplete; treat the new AI features as previews.

Performance history stays on your Mac. Model downloads, updates, signed content,
and network tools make network requests; they do not upload performance history.

## Further Reading

- [Full changelog](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.2.0.260/CHANGELOG.md).

- [GPU guide](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.2.0.260/docs/gpu-tab-design.md).

- [Ask preview scope](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.2.0.260/docs/ai-integration-prd.md#generative-preview).

- [Security policy](https://github.com/Zesty0wl/mac-performance-monitor/blob/v2.2.0.260/SECURITY.md).