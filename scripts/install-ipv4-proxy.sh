#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${CODEX_HOME:-$HOME/.codex}/figma-mcp-doctor"
LAUNCH_AGENT="$HOME/Library/LaunchAgents/com.danzai.codex-ipv4-proxy.plist"
NODE_BIN="$(command -v node || true)"

if [ -z "$NODE_BIN" ]; then
  if [ -x "/Applications/Codex.app/Contents/Resources/node" ]; then
    NODE_BIN="/Applications/Codex.app/Contents/Resources/node"
  else
    echo "ERROR: node not found"
    exit 1
  fi
fi

mkdir -p "$INSTALL_DIR" "$HOME/Library/LaunchAgents"
cp "$SCRIPT_DIR/ipv4-connect-proxy.js" "$INSTALL_DIR/ipv4-connect-proxy.js"

cat > "$LAUNCH_AGENT" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.danzai.codex-ipv4-proxy</string>
  <key>ProgramArguments</key>
  <array>
    <string>$NODE_BIN</string>
    <string>$INSTALL_DIR/ipv4-connect-proxy.js</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PROXY_PORT</key>
    <string>8877</string>
  </dict>
  <key>KeepAlive</key>
  <true/>
  <key>RunAtLoad</key>
  <true/>
  <key>StandardOutPath</key>
  <string>/tmp/codex-ipv4-proxy.out.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/codex-ipv4-proxy.err.log</string>
</dict>
</plist>
PLIST

launchctl bootout "gui/$(id -u)" "$LAUNCH_AGENT" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "$LAUNCH_AGENT"
launchctl setenv HTTPS_PROXY http://127.0.0.1:8877
launchctl setenv HTTP_PROXY http://127.0.0.1:8877
launchctl setenv NO_PROXY 127.0.0.1,localhost

echo "Installed IPv4 CONNECT proxy on http://127.0.0.1:8877"
echo "Set GUI env: HTTPS_PROXY, HTTP_PROXY, NO_PROXY"
echo "Fully quit and reopen Codex Desktop."
