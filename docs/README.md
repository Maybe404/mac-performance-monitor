# Documentation

Use these guides for Mac Performance Monitor 2.0. The source branch is `main`.
Published packages and Homebrew follow public releases, not every source change.

## Product And Support

- [Project overview and screenshots](../README.md).

- [2.0 release notes](../RELEASE_NOTES.md) and [changelog](../CHANGELOG.md).

- [Explorer](explorer-design.md): investigate recorded and live data at a chosen time.

- [Adaptive alerts](adaptive-alerts.md): growth rules, observations, snoozes,
  evidence, local state, and verification limits.

- [Security and privacy](../SECURITY.md): network access, permissions, exports,
  and private reporting.

- [Contributing](../CONTRIBUTING.md) and [translations](../TRANSLATING.md).

## Current Technical Guides

- [Dashboard chart standard](dashboard-chart-standard.md) applies to Dashboard
  and Explorer. It defines averages, recorded ranges, gaps, and source limits.

- [Memory taxonomy](memory-taxonomy.md) and [pressure index](pressure-index.md)
  explain the memory measurements.

- [Performance budget](performance-budget.md) records the monitoring cost goals.

- [Release checklist](release-checklist.md) separates local checks from signed
  upgrade testing and publication. [Homebrew](homebrew-submission.md) covers
  the distribution handoff.

## Design History

Earlier design and investigation notes remain available for context. Their
dated observations, proposed work, and old names such as Analytics are not
current product guarantees. Prefer the guides above for shipped behavior.

- [App presence](app-presence-design.md), [GPU](gpu-tab-design.md),
  [temperature](temperature-design.md), and [Disk Map](disk-map-design.md).

- [Earlier chart policy](chart-rules.md), superseded for Dashboard and Explorer.

- [Pre-redesign alert audit](alerting-audit-2026-09-10.md) and the
  [history-cache crash investigation](persistence-cache-crash-2026-09-07.md).

- [Data-layer findings](data-layer-findings.md) and the
  [file-descriptor investigation](fd-count-1620-diagnosis.md).

- Efficiency reviews from [3 July](efficiency-analysis-2026-07-03.md),
  [9 July](efficiency-analysis-2026-07-09.md), and
  [22 August](efficiency-analysis-2026-08-22.md).

- [Onboarding design](onboarding-and-accessibility.md),
  [helper visibility](reference/HELPER_NOT_READABLE_INVESTIGATION.md), and
  [Endpoint Security research](reference/ESF_INVESTIGATION.md).