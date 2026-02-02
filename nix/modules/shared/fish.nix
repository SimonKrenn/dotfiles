{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    plugins = lib.optional (pkgs.fishPlugins ? "fzf-fish") {
      name = "fzf-fish";
      src = pkgs.fishPlugins."fzf-fish".src;
    };

    shellInit = ''
      ${lib.optionalString pkgs.stdenv.isDarwin "fish_add_path /opt/homebrew/bin"}
      fish_add_path "$HOME/.local/share/bob/nvim-bin"
      fish_add_path "$HOME/.local/bin"
      fish_add_path "$HOME/.lmstudio/bin"
      set -q XDG_HOME || set -Ux XDG_HOME $HOME
      set -q EDITOR || set -Ux EDITOR nvim
    '';

    interactiveShellInit = ''
      if type -q op
        op completion fish | source
      end
    '';

    shellAliases = {
      erd = "erd -.";
      ls = "eza -a -g --icons";
      lg = "lazygit";
      edit = "nvim";
      browse = "yazi";
      ya = "yazi";
      y = "yarn";
      pn = "pnpm";
      g = "git";
      find = "fd";
      mux = "tmuxinator";
      cat = "bat";

      oot = "sesh connect $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/";
      oow = "cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/work/";
      oop = "cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten/";

      slast = "sesh last";
      sf = "source ~/.config/fish/config.fish";
    };

    functions = {
      ya = {
        body = ''
          set tmp (mktemp -t "yazi-cwd.XXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };

      wto = {
        description = "Create git worktree and launch opencode session";
        body = ''
          if test (count $argv) -lt 1
            echo "Usage: wto <branch-name>"
            return 1
          end

          set -l branch $argv[1]
          wt switch --create $branch -x opencode
        '';
      };
    };
  };
}
