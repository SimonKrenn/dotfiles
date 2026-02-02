{ config, lib, pkgs, ... }:
{
  xdg.configFile = {
    atuin = { source = ../../.config/atuin; };
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
  }
  // lib.optionalAttrs (!(config.programs.fish.enable or false)) {
    fish = { source = ../../.config/fish; };
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
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
