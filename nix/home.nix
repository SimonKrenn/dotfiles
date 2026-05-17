{...}:

{
  imports = [
    ./programs/fish.nix
    ./programs/ghostty.nix
    ./programs/lazygit.nix
    ./programs/yazi.nix
    ./programs/atuin.nix
  ];

  home.username = "simonkrenn";
  home.homeDirectory = "/Users/simonkrenn";

  home.stateVersion = "25.11";

  xdg.enable = true;

  programs.home-manager.enable = true;
    
  home.file.".config/nvim".source = ../.config/nvim;
  home.file.".config/tmux".source = ../.config/tmux;
  # home.file.".config/yazi".source = ../.config/yazi;
  home.file.".config/git".source = ../.config/git;
  # home.file.".config/lazygit".source = ../.config/lazygit;
  home.file.".config/hammerspoon".source = ../.config/hammerspoon;
  home.file.".config/mise".source = ../.config/mise;
  home.file.".config/sesh".source = ../.config/sesh;
  # home.file.".config/atuin".source = ../.config/atuin;
  home.file.".config/opencode".source = ../.config/opencode;
  home.file.".config/worktrunk".source = ../.config/worktrunk;
}
