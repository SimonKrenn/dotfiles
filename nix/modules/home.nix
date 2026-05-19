{ username, ... }:
{

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.11";
  };

  xdg.enable = true;

  programs.home-manager.enable = true;

  imports = [
    ../programs/fish.nix
    ../programs/ghostty.nix
    ../programs/lazygit.nix
    ../programs/yazi.nix
    ../programs/atuin.nix
    ../programs/hammerspoon.nix
    # ./programs/tmux.nix
  ];

  home.file.".config/nvim".source = ../../.config/nvim;
  home.file.".config/tmux/tmux.conf".source = ../../.config/tmux/.tmux.conf;
  home.file.".config/tmux/tmux.light.sh".source = ../../.config/tmux/tmux.light.sh;
  home.file.".config/tmux/tmux.dark.sh".source = ../../.config/tmux/tmux.dark.sh;
  # home.file.".config/yazi".source = ../.config/yazi;
  home.file.".config/git".source = ../../.config/git;
  # home.file.".config/lazygit".source = ../.config/lazygit;
  home.file.".config/mise".source = ../../.config/mise;
  home.file.".config/sesh".source = ../../.config/sesh;
  # home.file.".config/atuin".source = ../.config/atuin;
  home.file.".config/opencode".source = ../../.config/opencode;
  home.file.".config/worktrunk".source = ../../.config/worktrunk;
}
