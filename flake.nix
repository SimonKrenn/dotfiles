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

  outputs = {self, nixpkgs, nix-darwin, home-manager, nix-homebrew, devenv, ...}@inputs: {
      darwinConfigurations."simon-mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./nix/darwin.nix
          ./nix/homebrew.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "stow-backup";
            home-manager.users.simonkrenn = import ./nix/home.nix;
        }
      ];
    };
  };
}
