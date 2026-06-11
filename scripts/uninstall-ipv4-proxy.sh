#!/usr/bin/env bash
set -euo pipefail
LAUNCH_AGENT="$HOME/Library/LaunchAgents/com.danzai.codex-ipv4-proxy.plist"
launchctl bootout "gui/$(id -u)" "$LAUNCH_AGENT" >/dev/null 2>&1 || true
rm -f "$LAUNCH_AGENT"
launchctl unsetenv HTTPS_PROXY || true
launchctl unsetenv HTTP_PROXY || true
launchctl unsetenv NO_PROXY || true
echo "Removed IPv4 proxy LaunchAgent and unset GUI proxy env values."
