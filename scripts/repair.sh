#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="${CODEX_HOME:-$HOME/.codex}/config.toml"
python3 "$SCRIPT_DIR/patch-codex-config.py" "$CONFIG"

echo "\nChecking local Figma Desktop MCP..."
if curl -sS -I --connect-timeout 2 --max-time 5 http://127.0.0.1:3845/mcp >/dev/null; then
  echo "OK: Figma Desktop MCP is reachable."
else
  echo "WARN: Figma Desktop MCP is not reachable. Open Figma Desktop and enable the Dev Mode MCP server."
fi

echo "\nRun this if use_figma is still missing after restart:"
echo "  $SCRIPT_DIR/repair-use-figma.sh --login"
echo "\nImportant: fully quit and reopen Codex Desktop. Existing sessions do not hot-refresh tools."
