# nix-config

ultsaza's home-manager flake. Manages user-space CLI tools and `programs.*`
modules across multiple machines (Linux + macOS) from a single Nix flake.

## Layout

```
flake.nix              # inputs, outputs, mkHome helper
modules/
  common.nix           # shared across every host: CLI packages, direnv, etc.
hosts/
  mini.nix             # Mini (Linux x86_64) — username/homeDirectory
  # asus.nix           # placeholder for ASUS Linux laptop
  # mac.nix            # placeholder for macOS
```

To add a new host:

1. Run `hostname` on the target machine.
2. Add `hosts/<hostname>.nix` with `home.username` / `home.homeDirectory`.
3. Add an entry under `homeConfigurations` in `flake.nix`.
4. On the target: `nix run home-manager/master -- switch --flake ~/nix-config#ultsaza@<hostname> -b backup`.

## Day-to-day

```sh
# Edit modules/common.nix or hosts/mini.nix, then:
home-manager switch --flake ~/nix-config#ultsaza@Mini

# Rollback to previous generation:
home-manager generations
/nix/store/<id>-home-manager-generation/activate

# Update inputs (nixpkgs + home-manager):
nix flake update
home-manager switch --flake ~/nix-config#ultsaza@Mini
```

## Boundary: nix-config vs chezmoi (`~/dotfiles`)

This flake and chezmoi are **complementary**, not overlapping. Rule of thumb:

| Concern                          | Owned by    | Why                                                       |
| -------------------------------- | ----------- | --------------------------------------------------------- |
| CLI tool inventory (what's installed) | nix-config  | Declarative, reproducible across hosts, easy rollback     |
| `programs.direnv` / `fzf` / `bat` / `zoxide` config | nix-config  | Native HM modules; no per-host templating needed          |
| Hyprland config (`~/.config/hypr/`)     | chezmoi     | Complex per-host templating already in place              |
| aerospace (macOS)                | chezmoi     | macOS-only, templated                                     |
| Neovim config (`~/.config/nvim/`)       | chezmoi     | Existing investment, lua-heavy                            |
| VSCode settings/keybindings      | chezmoi     | Already managed under `private_dot_config/Code/`          |
| lazygit, wireplumber, Code, hypr `.config/` subdirs | chezmoi | Listed in `chezmoi managed` output            |
| Claude Code / Codex configs      | chezmoi     | Templated under `dot_claude/` `dot_codex/`                |
| `~/.zshrc`, `~/.p10k.zsh`, `~/.gitconfig` | **loose** (neither) | oh-my-zsh + p10k installer wrote these; leave alone for now |

**Do not enable** `programs.lazygit`, `programs.neovim`, `programs.zsh`, or any
HM module whose target file is chezmoi-managed — that creates a write conflict
on `home-manager switch`.

## Known overlap with apt

These packages are installed via both apt and nix:
`gh`, `helix` (binary `hx`), `btop`, `fastfetch`, `jq`, `lazygit` (if present).

The Nix versions win in PATH because `~/.nix-profile/bin` precedes
`/usr/bin` in the standard profile. The apt versions sit unused but harmless.
Purge them at leisure with `sudo apt remove <pkg>` if you want a clean state.

## Source

- Repo: `~/nix-config`
- Determinate Nix already provides `flakes` + `nix-command` experimentally enabled.
- After first switch, the `home-manager` CLI is in PATH from
  `~/.nix-profile/bin/home-manager`.
