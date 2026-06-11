---
name: figma-mcp-doctor
description: Use when Figma MCP, figma-desktop, remote Figma MCP, figma@openai-curated, or use_figma is missing, unstable, unauthorized, or unavailable in Codex. Diagnoses and repairs local Figma Desktop MCP, remote Figma OAuth, Codex Figma plugin sync, IPv4/proxy problems, and stale Codex tool lists.
---

# Figma MCP Doctor

Use this skill when a user says Figma MCP, `figma-desktop`, or `use_figma` is missing or unstable in Codex.

## Workflow

1. Run `scripts/doctor.sh` first. Do not modify config during diagnosis.
2. Separate findings into five buckets: local Figma Desktop MCP, remote Figma MCP / `use_figma`, OAuth/login, network/proxy, stale Codex session.
3. If read tools work but `use_figma` is missing, explain that `figma-desktop` is the local read chain and `use_figma` comes from the remote Figma plugin chain.
4. For normal config repair, run `scripts/repair.sh`.
5. For `use_figma` missing while read tools work, run `scripts/repair-use-figma.sh`; use `--login` only if the user approves an OAuth login flow.
6. Ask before installing IPv4 proxy or changing GUI environment variables. Use `scripts/install-ipv4-proxy.sh` only for network/plugin-sync instability.
7. Never print tokens, OAuth credentials, cookies, or secret env values.
8. Always tell the user to fully quit and reopen Codex Desktop after repair. Existing sessions do not hot-refresh MCP tools.

## Key Explanation

`figma-desktop` comes from the local Figma Desktop MCP server and usually provides read tools like `get_metadata`, `get_design_context`, `get_screenshot`, and `get_variable_defs`.

`use_figma` comes from the remote Figma plugin chain: `figma@openai-curated`, remote Figma MCP OAuth, Codex / ChatGPT login state, remote plugin sync, and network reachability.

Therefore: local Figma MCP working does not prove `use_figma` is available.

## References

- `references/troubleshooting.md`
- `references/use-figma-repair.md`
- `references/recovery-playbook.md`
