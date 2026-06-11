#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGIN="false"
for arg in "$@"; do
  case "$arg" in
    --login) LOGIN="true" ;;
    *) echo "Unknown arg: $arg"; exit 2 ;;
  esac
done

"$SCRIPT_DIR/repair.sh"

if command -v codex >/dev/null 2>&1; then
  if ! codex mcp get figma >/dev/null 2>&1; then
    echo "\nAdding remote Figma MCP..."
    codex mcp add figma --url https://mcp.figma.com/mcp || true
  fi
  if [ "$LOGIN" = "true" ]; then
    echo "\nStarting Figma MCP OAuth login..."
    codex mcp login figma
  else
    echo "\nSkipping OAuth login. If remote Figma MCP is not OAuth-authenticated, run:"
    echo "  codex mcp login figma"
  fi
fi

echo "\nIf use_figma is still missing after OAuth, check remote plugin sync / ChatGPT login / network."
echo "If your network has IPv6 TLS reset issues, run:"
echo "  $SCRIPT_DIR/install-ipv4-proxy.sh"
echo "\nImportant: fully quit and reopen Codex Desktop after this repair."
