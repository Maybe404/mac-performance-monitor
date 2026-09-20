#!/usr/bin/env bash
#
# build.sh — compile the MacPerfMonitor binary with Swift Package Manager.
#
# This is an Apple Silicon (arm64) only project: we build for the host arch and
# never produce a universal or x86_64 binary.
#
# Release by default. Flags:
#   --debug      faster, unoptimised build
#   --release    optimised build (default)
#
set -euo pipefail
cd "$(dirname "$0")/.."

CONFIG="release"
for arg in "$@"; do
  case "$arg" in
    --debug)     CONFIG="debug" ;;
    --release)   CONFIG="release" ;;
    --universal)
      echo "build.sh: --universal is not supported; this is an Apple Silicon (arm64) only project." >&2
      exit 2 ;;
    *) echo "build.sh: ignoring unknown argument '$arg'" >&2 ;;
  esac
done

if ! METAL="$(xcrun --find metal 2>/dev/null)" || ! "$METAL" --version >/dev/null 2>&1; then
  echo "build.sh: the Metal compiler is unavailable. Install it with:" >&2
  echo "  xcodebuild -downloadComponent MetalToolchain" >&2
  exit 1
fi

METAL_STAMP=".build/.metal-toolchain-path"
if [[ ! -f "$METAL_STAMP" ]] || [[ "$(< "$METAL_STAMP")" != "$METAL" ]]; then
  if [[ -d .build ]]; then
    echo "==> Metal compiler location changed or was not recorded; cleaning SwiftPM build artifacts"
    swift package clean
  fi
  mkdir -p .build
  printf '%s\n' "$METAL" > "$METAL_STAMP"
fi

echo "Building MacPerfMonitor ($CONFIG, arm64)..."
swift build -c "$CONFIG" --product MacPerfMonitor
# The privileged helper is a separate executable product (the app does not
# depend on it), so it must be built explicitly to be bundled alongside the app.
swift build -c "$CONFIG" --product MacPerfMonitorHelper
swift build -c "$CONFIG" --product MacPerfMonitorInference

BIN="$(swift build --show-bin-path -c "$CONFIG")/MacPerfMonitor"
echo "Built: $BIN"
