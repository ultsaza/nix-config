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
}
