{ pkgs, ... }:
{
  xdg.enable = true;

  home.packages = with pkgs; [
    bat
    eza
    fd
    fzf
    git
    ripgrep
    starship
    zoxide
  ];

  programs.bat.enable = true;
  programs.eza.enable = true;
  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.git.enable = true;
  programs.ripgrep.enable = true;
  programs.starship.enable = true;
  programs.zoxide.enable = true;
}
