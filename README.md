# Figma MCP Doctor

Diagnose and repair Figma MCP, `figma-desktop`, and `use_figma` issues in Codex Desktop.

## What this fixes

This plugin is for Codex users who see problems like:

- Figma MCP tools are missing in Codex.
- `figma-desktop` works, but `use_figma` does not appear.
- `get_metadata`, `get_design_context`, or `get_screenshot` works, but Figma write actions do not.
- Remote Figma MCP OAuth is missing or unstable.
- Figma tools disappear after config changes.
- Remote Figma plugin sync is unstable because of network / IPv6 issues.

## Key idea

`figma-desktop` and `use_figma` are different chains:

- `figma-desktop` is the local Figma Desktop MCP server. It usually provides read tools.
- `use_figma` comes from the remote Figma plugin chain: `figma@openai-curated`, remote Figma MCP OAuth, Codex / ChatGPT login state, remote plugin sync, and network reachability.

So: local Figma MCP working does not prove `use_figma` is available.

## Scripts

```bash
./scripts/doctor.sh
./scripts/repair.sh
./scripts/repair-use-figma.sh --login
./scripts/install-ipv4-proxy.sh
./scripts/uninstall-ipv4-proxy.sh
```

Recommended order:

1. Run `doctor.sh` first.
2. Run `repair.sh` for normal config repair.
3. Run `repair-use-figma.sh --login` when read tools work but `use_figma` is missing.
4. Run `install-ipv4-proxy.sh` only when remote plugin sync or network reachability is unstable.
5. Fully quit and reopen Codex Desktop after any repair.

## Safety

- The scripts back up `~/.codex/config.toml` before patching.
- The scripts do not print tokens, cookies, or OAuth secrets.
- The IPv4 proxy is opt-in and can be removed with `uninstall-ipv4-proxy.sh`.

## Typical prompt in Codex

```text
My Figma MCP works for get_metadata, but use_figma is missing. Use figma-mcp-doctor to diagnose and repair it.
```
