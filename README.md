# figma-mcp-doctor
这是一个 Codex 插件：figma-mcp-doctor。 它专门修复 Codex 里 Figma MCP、figma-desktop、use_figma 经常失效的问题。 特别适合 “get_metadata 能用，但 use_figma 不出现” 的情况，因为这代表本地读链路通了，但远程写入链路没暴露。 插件会自动诊断本地 Figma Desktop MCP、远程 Figma MCP OAuth、figma@openai-curated 插件、ChatGPT 登录态、IPv4 代理和 Codex 旧会话缓存。
