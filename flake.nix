{
  description = "Nix dotfiles configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    devenv = {
      url = "github:cachix/devenv";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      devenv,
      ...
    }@inputs:
    let
      mkHost =
        {
          hostname,
          system,
          username,
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit hostname username; };
          modules = [
            # ./nix/hosts/${hostname}/default.nix
            ./nix/modules/darwin.nix
            ./nix/modules/homebrew.nix

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit hostname username; };

              home-manager.users.${username} = {
                imports = [
                  ./nix/modules/home.nix
                  ./nix/hosts/${hostname}/default.nix
                ];
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        simon-mac = mkHost {
          hostname = "simon-mac";
          system = "aarch64-darwin";
          username = "simonkrenn";
        };
        work = mkHost {
          hostname = "work";
          system = "aarch64-darwin";
          username = "simon";
        };
      };
    };
}
