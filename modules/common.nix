{ pkgs, lib, ... }:
{
  # Baseline shared across every machine. Host modules only carry differences.

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # System inspection
    btop
    fastfetch

    # Search and navigation
    ripgrep
    fd
    eza

    # Git / dev workflow
    gh
    lazygit

    # Structured data
    jq

    # Misc CLI
    yt-dlp
    tealdeer
    hyperfine
    tokei
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    # WireGuard CLI: `wg` for keygen/status. Connection lifecycle is handled
    # by NetworkManager (built-in support since NM 1.16). macOS uses the
    # official WireGuard.app instead, so this stays Linux-only.
    wireguard-tools
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.bat.enable = true;

  # Go toolchain. Replaces the manual /usr/local/go tarball (go1.25.4) and the
  # apt golang-1.22 packages — Nix is now the single source of truth, kept
  # current via `nix flake update`. GOPATH stays the default (~/go); tools
  # installed with `go install` (gopls, staticcheck, …) live in ~/go/bin, which
  # ~/.zshrc already puts on PATH and is complementary to this.
  programs.go.enable = true;
}
