{ pkgs, ... }:
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

    # Editor
    helix

    # Structured data
    jq

    # Misc CLI
    yt-dlp
    tealdeer
    hyperfine
    tokei
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;
  programs.zoxide.enable = true;
  programs.bat.enable = true;
}
