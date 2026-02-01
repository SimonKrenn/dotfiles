{ lib, pkgs, ... }:
{
  xdg.configFile = {
    atuin = { source = ../../.config/atuin; };
    fish = { source = ../../.config/fish; };
    git = { source = ../../.config/git; };
    lazygit = { source = ../../.config/lazygit; };
    mise = { source = ../../.config/mise; };
    nvim = { source = ../../.config/nvim; };
    opencode = { source = ../../.config/opencode; };
    sesh = { source = ../../.config/sesh; };
    tmux = { source = ../../.config/tmux; };
    tmuxinator = { source = ../../.config/tmuxinator; };
    worktrunk = { source = ../../.config/worktrunk; };
    yazi = { source = ../../.config/yazi; };
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    ghostty = { source = ../../.config/ghostty; };
    hammerspoon = { source = ../../.config/hammerspoon; };
    skhd = { source = ../../.config/skhd; };
  };

  home.file = {
    ".tmux.conf" = {
      source = ../../.config/tmux/.tmux.conf;
    };
  };
}
