#!/usr/bin/env bash
set -euo pipefail

CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CONFIG="$CODEX_HOME/config.toml"

echo "== Figma MCP Doctor =="
echo "config: $CONFIG"

if command -v codex >/dev/null 2>&1; then
  printf "\n== Codex MCP servers ==\n"
  codex mcp list || true
  printf "\n== Figma remote MCP ==\n"
  codex mcp get figma || true
else
  echo "codex command not found"
fi

printf "\n== Config checks ==\n"
if [ -f "$CONFIG" ]; then
  grep -n 'figma\|enable_mcp_apps\|rmcp_client\|openai-curated' "$CONFIG" || true
else
  echo "missing config"
fi

printf "\n== Local Figma Desktop MCP ==\n"
if curl -sS -I --connect-timeout 2 --max-time 5 http://127.0.0.1:3845/mcp >/tmp/figma-mcp-doctor-local.headers 2>/tmp/figma-mcp-doctor-local.err; then
  echo "reachable: http://127.0.0.1:3845/mcp"
  sed -n '1,8p' /tmp/figma-mcp-doctor-local.headers
else
  echo "not reachable: http://127.0.0.1:3845/mcp"
  cat /tmp/figma-mcp-doctor-local.err || true
fi

if command -v lsof >/dev/null 2>&1; then
  lsof -nP -iTCP:3845 -sTCP:LISTEN || true
fi

printf "\n== Figma plugin ==\n"
if command -v codex >/dev/null 2>&1; then
  codex plugin list | awk 'BEGIN{show=0} /Marketplace/ {show=0} /figma@openai-curated/ {print; found=1} END{if(!found) print "figma@openai-curated not found"}' || true
fi

printf "\n== Proxy environment, redacted ==\n"
for name in HTTPS_PROXY HTTP_PROXY NO_PROXY; do
  value="${!name-}"
  if [ -n "$value" ]; then
    echo "$name=present ($value)"
  else
    echo "$name=missing"
  fi
done

printf "\n== IPv4 proxy LaunchAgent ==\n"
if launchctl print "gui/$(id -u)/com.danzai.codex-ipv4-proxy" >/tmp/figma-mcp-doctor-launchagent.txt 2>/dev/null; then
  awk '/^	path = / || /^	state = / || /^	pid = / || /^	runs = / {print}' /tmp/figma-mcp-doctor-launchagent.txt
else
  echo "not loaded"
fi
rm -f /tmp/figma-mcp-doctor-launchagent.txt

printf "\n== Codex doctor summary ==\n"
if command -v codex >/dev/null 2>&1; then
  codex doctor --summary --no-color --ascii || true
fi
