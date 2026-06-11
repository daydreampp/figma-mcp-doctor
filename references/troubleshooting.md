# Troubleshooting Matrix

| Problem | Signal | Fix |
|---|---|---|
| Figma Desktop is not running | `127.0.0.1:3845/mcp` is unreachable | Open Figma Desktop and enable Dev Mode MCP server. |
| Local MCP missing | `codex mcp list` has no `figma-desktop` | Add `[mcp_servers."figma-desktop"]`. |
| Figma plugin missing | `figma@openai-curated` is not installed/enabled | Install or enable the plugin. |
| Remote Figma MCP missing | `codex mcp list` has no `figma` remote server | Add `https://mcp.figma.com/mcp`. |
| OAuth missing | `codex mcp get figma` is not OAuth-authenticated | Run `codex mcp login figma`. |
| `use_figma` missing but read tools work | local chain works, remote write chain missing | Repair remote Figma MCP, plugin sync, login, and network. |
| Tools still missing after repair | Old Codex session | Fully quit and reopen Codex Desktop. |
| Remote plugin sync unstable | timeouts, TLS reset, tools appear/disappear | Install IPv4 CONNECT proxy if needed. |
| Local MCP breaks after proxy | localhost is proxied | Set `NO_PROXY=127.0.0.1,localhost`. |
