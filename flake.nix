{
  description = "ultsaza home-manager configurations across machines";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      mkHome = { system, hostModule }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            ./modules/common.nix
            hostModule
          ];
        };
    in {
      homeConfigurations = {
        # Linux desktop (hostname: Mini)
        "ultsaza@Mini" = mkHome {
          system = "x86_64-linux";
          hostModule = ./hosts/mini.nix;
        };

        # Placeholders — fill in real hostname later with `hostname` on each box.
        # "ultsaza@<asus-hostname>" = mkHome {
        #   system = "x86_64-linux";
        #   hostModule = ./hosts/asus.nix;
        # };
        # "ultsaza@<mac-hostname>" = mkHome {
        #   system = "aarch64-darwin";  # or x86_64-darwin
        #   hostModule = ./hosts/mac.nix;
        # };
      };
    };
}
