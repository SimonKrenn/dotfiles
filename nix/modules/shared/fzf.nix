{ config, lib, ... }:
{
  programs.fzf =
    {
      enable = true;
    }
    // lib.optionalAttrs (config.programs.fish.enable or false) {
      enableFishIntegration = true;
    };

  programs.fish = lib.mkIf (config.programs.fish.enable or false) {
    interactiveShellInit = ''
      if type -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --variables=\cv
      end
    '';

    shellAliases = {
      slist = "sesh connect (sesh list --icons | fzf --no-sort --ansi)";
    };
  };
}
