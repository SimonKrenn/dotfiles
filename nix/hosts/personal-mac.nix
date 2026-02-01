{ lib, ... }:
let
  user_secrets = ../secrets/personal.nix;
in
{
  networking.hostName = lib.mkDefault "personal-mac";

  users.users.personal = {
    home = lib.mkDefault "/Users/personal";
  };

  home-manager.users.personal = {
    imports = [
      ../modules/shared/base.nix
      ../modules/shared/dotfiles.nix
      ../modules/darwin/base.nix
      ../users/personal.nix
    ] ++ lib.optional (builtins.pathExists user_secrets) user_secrets;

    home.username = lib.mkDefault "personal";
    home.homeDirectory = lib.mkDefault "/Users/personal";
  };
}
