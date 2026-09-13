# Dotfiles review — 2026-09-12

Reviewed the flake, shared system and Home Manager modules, Darwin configuration, editor/terminal settings, and documentation. NixOS-specific code and the Steam helper were reviewed separately; follow-up work is in [NIXOS-REVIEW.md](NIXOS-REVIEW.md) for the sauron reinstall.

## Fixed

| Priority | Location | Finding and resulting behavior |
| --- | --- | --- |
| High | [1Password](home-modules/onepassword.nix) | The configured `~/.1password/agent.sock` did not exist on legolas, while the app-group socket did. macOS now uses the app's actual socket, quoted correctly in SSH configuration. Linux retains its existing socket path. |
| Medium | [SSH agent selection](home-modules/onepassword.nix) | An unconditional `IdentityAgent` overrode forwarded `SSH_AUTH_SOCK`, defeating the shell's forwarding guard. A preceding `Match` block now preserves the agent in incoming SSH sessions; local clients retain the 1Password fallback. |
| Medium | [Git](home-modules/git.nix) | `signer = signer` failed the configured statix check and therefore `nix flake check`. Changed to `inherit signer`, preserving the existing signing setup. |
| Medium | [Zed](home-modules/zed.nix) | `jsonls` and `yamlls` were not Zed's adapter names. They now use `json-language-server` and `yaml-language-server`. StyLua now receives `-` to format stdin and the buffer path to discover project configuration. |
| Medium | [Helix](home-modules/helix.nix) | Python's defaults selected uninstalled type-checking servers, leaving only Ruff available despite Pyright being installed. Explicitly selected Pyright and Ruff, with Ruff formatting. Nix explicitly uses nixd and nixfmt, removing the unused nil lookup. |
| Medium | [LLM environment](home-modules/llm-env.nix) | Fish removed all leading/trailing quote characters, corrupting quoted values containing literal quotes, and attempted to export invalid variable names. It now removes one matching quote pair, validates names, preserves empty values, and handles CRLF. Bash/zsh snippets preserve the existing `allexport` option. Deprecated zsh `initExtra` settings were migrated to `initContent` here and in the SSH module. |
| Medium | [Zellij](home-modules/zellij.kdl) | Double Ctrl-A sent Ctrl-B; the floating-pane binding toggled visibility twice and depended on the initial state; search had no next/previous bindings; copy/edit-scrollback bindings were in an unreachable mode. Fixed the transmitted byte, explicit floating Fish creation, search traversal, and reachable scrollback actions. Escape exits prefix/search mode. |
| Low | [Documentation](README.md) | Clarified that Bash/zsh Home Manager modules are disabled, documented the portable secrets-file format and platform socket paths, and distinguished cross-platform evaluation from building checks. Removed trailing whitespace in AGENTS.md. |

The SSH changes follow OpenSSH's first-value-wins and `IdentityAgent` rules in the [SSH client manual](https://man.openbsd.org/ssh_config). Editor fixes were checked against Zed's [JSON](https://zed.dev/docs/languages/json), [YAML](https://zed.dev/docs/languages/yaml), and [Lua](https://zed.dev/docs/languages/lua) documentation, and Helix's [language configuration](https://docs.helix-editor.com/languages.html). Zellij behavior was checked against its [action reference](https://zellij.dev/documentation/keybindings-possible-actions).

## Validation

- `nix flake check --no-update-lock-file`: passed, including Darwin host evaluation, nixfmt, and statix. The command also evaluated the sauron configuration; Linux check derivations were not built on macOS.
- Direct Darwin Home Manager warnings evaluation: empty list.
- Built the generated Fish, Ghostty, Helix, and tmux configuration files without activating them.
- Fish syntax check and Ghostty's config validator: passed.
- Helix health checks against the generated configuration: Pyright, Ruff, nixd, and the configured Python/Nix formatters found; language configuration parsed successfully.
- Started and stopped a separate tmux test server with the generated configuration; confirmed `C-a` and `tmux-256color`.
- Zellij 0.45.1 `setup --check`: configuration well defined.
- Synthetic shell tests: Fish/bash/zsh preserved empty, quoted, literal-quote, and equals-containing values; Bash/zsh preserved both enabled and disabled `allexport`. Fish also handled invalid names, comments, CRLF, and a final line without a newline.
- `ssh -G` against generated configuration: local and forwarded-agent selection and the sauron host alias passed without opening a network connection.
- Zed's configured StyLua command formatted a synthetic stdin buffer successfully.
- `git diff --check` and standalone `statix check .`: passed.

## Handoff

The working tree already contained edits to AGENTS.md, README.md, Darwin cleanup retention, flake checks, Git signing, the LLM secrets path, OpenCode permissions, and development-tool comments. These were preserved; the flake lock was not updated. No commits or system switches were performed.

Apply the shared/macOS fixes on legolas with:

```sh
nix run nix-darwin -- switch --flake .#legolas
```

After activation, open a new Fish shell and restart the affected applications/sessions as needed. GUI authentication, end-to-end signing, interactive Zed language-server behavior, and sauron hardware/session behavior were not exercised. Rust/Go/C/C++/Zig language tools remain supplied by project devenv shells as intended.
