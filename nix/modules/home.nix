{
  username,
  lib,
  miseManaged ? false,
  ...
}:
{

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.11";
  };

  xdg.enable = true;

  programs.home-manager.enable = true;

  imports = lib.optionals (!miseManaged) [
    ../programs/git.nix
    ../programs/fish.nix
    ../programs/ghostty.nix
    ../programs/lazygit.nix
    ../programs/yazi.nix
    ../programs/atuin.nix
    ../programs/hammerspoon.nix
  ];

  home.file = lib.mkIf (!miseManaged) {
    ".config/nvim".source = ../../.config/nvim;
    ".config/tmux/tmux.conf".source = ../../.config/tmux/.tmux.conf;
    ".config/tmux/tmux.light.sh".source = ../../.config/tmux/tmux.light.sh;
    ".config/tmux/tmux.dark.sh".source = ../../.config/tmux/tmux.dark.sh;
    ".config/mise".source = ../../.config/mise;
    ".config/sesh".source = ../../.config/sesh;
    ".config/opencode".source = ../../.config/opencode;
    ".config/worktrunk".source = ../../.config/worktrunk;
  };
}
