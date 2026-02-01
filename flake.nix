{
  description = "Dotfiles via nix-darwin and home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    let
      mkDarwinHost = { system, hostModule }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            hostModule
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
          ];
        };

      mkHomeHost = { system, hostModule }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [ hostModule ];
        };
    in
    {
      darwinConfigurations = {
        work-mac = mkDarwinHost {
          system = "aarch64-darwin";
          hostModule = ./nix/hosts/work-mac.nix;
        };
        personal-mac = mkDarwinHost {
          system = "aarch64-darwin";
          hostModule = ./nix/hosts/personal-mac.nix;
        };
      };

      homeConfigurations = {
        linux-laptop = mkHomeHost {
          system = "x86_64-linux";
          hostModule = ./nix/hosts/linux-laptop.nix;
        };
      };
    };
}
