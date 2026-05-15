{ ... }:
{
  home.username = "ultsaza";
  home.homeDirectory = "/home/ultsaza";

  # Mini-specific overrides go here. Currently nothing — common.nix covers all.
  #
  # Note (2026-05-15): Discord was tried under home-manager but reverted —
  # Chromium SUID sandbox requires setuid root in /nix/store, which works on
  # NixOS via a security wrapper but not on Ubuntu. Discord stays on apt.
}
