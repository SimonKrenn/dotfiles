{config, pkgs, ...}:

{
  home.username = "simonkrenn";
  home.homeDirectory = "/Users/simonkrenn";
  
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.file.".config/fish".source = ../.config/fish;
  home.file.".config/nvim".source = ../.config/nvim;
  home.file.".config/tmux".source = ../.config/tmux;
  home.file.".config/yazi".source = ../.config/yazi;
  home.file.".config/git".source = ../.config/git;
  home.file.".config/lazygit".source = ../.config/lazygit;
  home.file.".config/ghostty".source = ../.config/ghostty;
  home.file.".config/hammerspoon".source = ../.config/hammerspoon;
  home.file.".config/mise".source = ../.config/mise;
  home.file.".config/sesh".source = ../.config/sesh;
}
