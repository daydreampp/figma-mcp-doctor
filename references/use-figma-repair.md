# use_figma Repair Notes

`use_figma` is not provided by the local Figma Desktop MCP server. The local server usually exposes read-oriented tools such as `get_metadata`, `get_design_context`, `get_screenshot`, and `get_variable_defs`.

`use_figma` depends on the remote Figma plugin chain:

- `figma@openai-curated` plugin installed and enabled.
- Remote Figma MCP configured at `https://mcp.figma.com/mcp`.
- Remote Figma MCP OAuth login completed.
- Codex / ChatGPT login state healthy.
- Remote plugin sync working.
- Network path to ChatGPT / Figma stable.
- New Codex session opened after repair.

If local read tools work but `use_figma` is missing, repair the remote chain and restart Codex Desktop.
