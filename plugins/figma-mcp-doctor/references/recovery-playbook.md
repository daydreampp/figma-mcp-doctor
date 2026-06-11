# Recovery Playbook

1. Run `scripts/doctor.sh`.
2. If `figma-desktop` is missing, run `scripts/repair.sh`.
3. If `use_figma` is missing but read tools work, run `scripts/repair-use-figma.sh --login`.
4. If remote plugin sync is unstable, run `scripts/install-ipv4-proxy.sh`.
5. Fully quit and reopen Codex Desktop.
6. Start a new Codex session and check whether `use_figma` appears.
7. If still missing, check Codex / ChatGPT login state and remote plugin sync.
