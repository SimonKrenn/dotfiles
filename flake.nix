{
  description = "Nix dotfiles configuration";
  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
      nixpkgs-darwin.url = "github:NixOs/nixpkgs/nixpkgs-25.11-darwin";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-darwin = {
        url = "github:lnl7/nix-darwin/nix-darwin-25.11";
        inputs.nixpkgs.follows = "nixpkgs-darwin";
      };

      nix-homebrew = {
        url = "github:zheaofengli/nix-homebrew";
      };

      devenv = {
        url = "github:cachix/devenv";
      };
  };

  outputs = {self, nixpkgs, nix-darwin, home-manager, nix-homebrew, devenv}@inputs: {
      darwinConfigurations."simon-mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin/default.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.simonkrenn = import ./home;
        }
      ]  
    };
  };
}
