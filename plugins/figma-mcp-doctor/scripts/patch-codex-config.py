#!/usr/bin/env python3
import datetime
import shutil
import sys
from pathlib import Path

REMOTE_FIGMA = '''
[mcp_servers.figma]
url = "https://mcp.figma.com/mcp"
startup_timeout_sec = 20
tool_timeout_sec = 120
'''

LOCAL_FIGMA = '''
[mcp_servers."figma-desktop"]
url = "http://127.0.0.1:3845/mcp"
startup_timeout_sec = 20
tool_timeout_sec = 120
'''

FIGMA_PLUGIN = '''
[plugins."figma@openai-curated"]
enabled = true
'''

FEATURES = {
    "rmcp_client": "true",
    "enable_mcp_apps": "true",
}


def upsert_features(text: str) -> str:
    lines = text.splitlines()
    if "[features]" not in [line.strip() for line in lines]:
        prefix = "[features]\n" + "\n".join(f"{k} = {v}" for k, v in FEATURES.items()) + "\n\n"
        return prefix + text

    out = []
    in_features = False
    seen = {key: False for key in FEATURES}
    for line in lines:
        stripped = line.strip()
        if stripped == "[features]":
            in_features = True
            out.append(line)
            continue
        if in_features and line.startswith("["):
            for key, value in FEATURES.items():
                if not seen[key]:
                    out.append(f"{key} = {value}")
            in_features = False
            out.append(line)
            continue
        if in_features:
            key = line.split("=", 1)[0].strip()
            if key in FEATURES:
                out.append(f"{key} = {FEATURES[key]}")
                seen[key] = True
            else:
                out.append(line)
        else:
            out.append(line)

    if in_features:
        for key, value in FEATURES.items():
            if not seen[key]:
                out.append(f"{key} = {value}")
    return "\n".join(out) + "\n"


def has_section(text: str, section: str) -> bool:
    return any(line.strip() == section for line in text.splitlines())


def append_before_projects(text: str, block: str) -> str:
    marker = "\n[projects."
    if marker in text:
        index = text.index(marker)
        return text[:index].rstrip() + "\n" + block.strip() + "\n" + text[index:]
    return text.rstrip() + "\n" + block.strip() + "\n"


def main() -> int:
    config = Path(sys.argv[1]).expanduser() if len(sys.argv) > 1 else Path.home() / ".codex" / "config.toml"
    if not config.exists():
        print(f"ERROR: config not found: {config}")
        return 1

    backup = config.with_name(config.name + ".bak.figma-mcp-doctor." + datetime.datetime.now().strftime("%Y%m%d%H%M%S"))
    shutil.copy2(config, backup)
    text = config.read_text()
    text = upsert_features(text)

    if not has_section(text, '[mcp_servers."figma-desktop"]'):
        text = append_before_projects(text, LOCAL_FIGMA)
    if not has_section(text, "[mcp_servers.figma]"):
        text = append_before_projects(text, REMOTE_FIGMA)
    if not has_section(text, '[plugins."figma@openai-curated"]'):
        text = append_before_projects(text, FIGMA_PLUGIN)

    config.write_text(text)
    print(f"patched={config}")
    print(f"backup={backup}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
