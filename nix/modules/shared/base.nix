{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./fzf.nix
  ];

  xdg.enable = true;

  home.packages = with pkgs; [
    atuin
    bat
    direnv
    eza
    fd
    git
    ripgrep
    starship
    zoxide
  ];

  programs.bat.enable = true;
  programs.atuin.enable = true;
  programs.direnv.enable = true;
  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.git.enable = true;
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;
}
