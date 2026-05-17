{ ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      erd = "erd -.";
      ls = "eza -a -g --icons";
      lg = "lazygit";
      edit = "nvim";
      browse = "yazi";
      y = "yarn";
      pn = "pnpm";
      g = "git";
      find = "fd";
      mux = "tmuxinator";
      cat = "bat";
      nv = "nvim";

      # obsidian
      oot = "sesh connect $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/";
      oow = "cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/work/";
      oop = "cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten/";

      # sesh
      slast = "sesh last";
      sf = "source ~/.config/fish/config.fish";

      # nix
      rebuild = "sudo darwin-rebuild switch --flake .#simon-mac";
    };

    interactiveShellInit = ''
      starship init fish | source
      zoxide init fish --cmd cd | source
      direnv hook fish | source
      op completion fish | source
      fzf --fish | source
      atuin init fish | source
      if test -f ~/.config/fish/private-alias.fish
        source ~/.config/fish/private-alias.fish
      end
      if test -f ~/.config/fish/local.fish
        source ~/.config/fish/local.fish
      end

      set -gx EDITOR nvim
      set -gx VISUAL nvim
      set -gx XDG_CONFIG_HOME $HOME/.config
      set -gx XDG_HOME $HOME

      fish_add_path ~/.local/bin
      fish_add_path ~/.bun/bin
      fish_add_path ~/.browser-use/bin
      fish_add_path ~/.browser-use-env/bin
      fish_add_path ~/.git-ai/bin
      fish_add_path -g "/run/current-system/sw/bin"
      set -g fish_color_command 53A1FA
      set -g fish_color_param 5BD1B9
      set -g fish_color_quote f9c35a
      set -g fish_color_error F44747
      set -g fish_color_keyword B267E6
      set -g fish_color_option 53A1FA
      set -g fish_color_valid_path --underline
    '';
    functions = {
      ya = ''
        set tmp (mktemp -t "yazi-cwd.XXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
          cd -- "$cwd"
        end
        rm -f -- "$tmp"
      '';
      oc = {
        wraps = "opencode";
        body = ''
          if test (count $argv) -gt 0
            switch $argv[1]
              case list
                set -l sessions (command opencode session list --format json | jq -r '.[] | [.id,.title,.directory] | @tsv')
                set -l selected (printf '%s\n' $sessions | fzf --delimiter="\t" --height=40% --popup center)
                set -l id (echo $selected | awk '{print $1}')
                if test -z "$id"
                  return
                end
                command opencode -s $id
                return
            end
          end
          command opencode $argv
        '';
      };
    };
  };
}
