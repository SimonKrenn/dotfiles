{ lib, ... }:
let
  user_secrets = ../secrets/personal.nix;
in
{
  imports = [
    ../modules/shared/base.nix
    ../modules/shared/dotfiles.nix
    ../modules/linux/base.nix
    ../users/personal.nix
  ] ++ lib.optional (builtins.pathExists user_secrets) user_secrets;

  home.username = lib.mkDefault "personal";
  home.homeDirectory = lib.mkDefault "/home/personal";
}
