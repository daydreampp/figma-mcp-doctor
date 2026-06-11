# Figma MCP Doctor

A Codex plugin that diagnoses and repairs Figma MCP, `figma-desktop`, and `use_figma` issues in Codex Desktop.

## Install

Run these commands in Terminal:

```bash
codex plugin marketplace add daydreampp/figma-mcp-doctor
codex plugin add figma-mcp-doctor@figma-mcp-doctor
```

Then fully quit and reopen Codex Desktop.

## Use in Codex

After installing, ask Codex:

```text
My Figma MCP works for get_metadata, but use_figma is missing. Use figma-mcp-doctor to diagnose and repair it.
```

Or:

```text
Use figma-mcp-doctor to run a diagnosis first. Do not change config until you explain the findings.
```

## What it fixes

This plugin helps with these common cases:

- `figma-desktop` is missing from Codex.
- Figma Desktop MCP is not reachable at `127.0.0.1:3845/mcp`.
- `get_metadata`, `get_design_context`, or `get_screenshot` works, but `use_figma` is missing.
- `figma@openai-curated` is not installed or enabled.
- Remote Figma MCP OAuth is missing.
- Codex Desktop has stale tools after config changes.
- Remote plugin sync is unstable because of network / IPv6 issues.

## Key idea

`figma-desktop` and `use_figma` are different chains:

- `figma-desktop` is the local Figma Desktop MCP server. It usually provides read tools.
- `use_figma` comes from the remote Figma plugin chain: `figma@openai-curated`, remote Figma MCP OAuth, Codex / ChatGPT login state, remote plugin sync, and network reachability.

So: local Figma MCP working does not prove `use_figma` is available.

## Scripts

The plugin includes:

```bash
plugins/figma-mcp-doctor/scripts/doctor.sh
plugins/figma-mcp-doctor/scripts/repair.sh
plugins/figma-mcp-doctor/scripts/repair-use-figma.sh --login
plugins/figma-mcp-doctor/scripts/install-ipv4-proxy.sh
plugins/figma-mcp-doctor/scripts/uninstall-ipv4-proxy.sh
```

Recommended order:

1. Run diagnosis first.
2. Use safe repair for normal config issues.
3. Use `repair-use-figma` when read tools work but `use_figma` is missing.
4. Use IPv4 proxy repair only when remote plugin sync/network is unstable.
5. Fully quit and reopen Codex Desktop after any repair.

## Safety

- The scripts back up `~/.codex/config.toml` before patching.
- The scripts do not print tokens, cookies, or OAuth secrets.
- The IPv4 proxy is opt-in and can be removed.
