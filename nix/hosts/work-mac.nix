{ lib, ... }:
let
  user_secrets = ../secrets/work.nix;
in
{
  networking.hostName = lib.mkDefault "work-mac";

  users.users.work = {
    home = lib.mkDefault "/Users/work";
  };

  home-manager.users.work = {
    imports = [
      ../modules/shared/base.nix
      ../modules/shared/dotfiles.nix
      ../modules/darwin/base.nix
      ../users/work.nix
    ] ++ lib.optional (builtins.pathExists user_secrets) user_secrets;

    home.username = lib.mkDefault "work";
    home.homeDirectory = lib.mkDefault "/Users/work";
  };
}
