{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;

    shell = "${pkgs.fish}/bin/fish";
    mouse = true;
    keyMode = "vi";
    prefix = "M-a";
    baseIndex = 1;
    customPaneNavigationAndResize = false;

    terminal = "$TERM";

    extraConfig = ''
      # Ghostty passthrough
      set -gq allow-passthrough on
      set -g visual-activity off
      set -g visual-bell off

      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      set -as terminal-overrides ',*:Setulc=\E[58::2::::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      # Window renumbering
      set-option -g renumber-windows on

      # Bell action
      set -g monitor-bell on
      set -g bell-action other

      # Status bar background
      set -g status-style 'bg=terminal'

      # Custom keymaps
      bind-key h split-window -h
      bind-key v split-window -v
      bind-key K run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 80%,70% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
          --preview-window 'right:55%' \
          --preview 'sesh preview {}'
        )\""

      # --- Plugins via TPM ---
      set -g @plugin 'christoomey/vim-tmux-navigator'
      set -g @plugin 'sainnhe/tmux-fzf'
      set -g @plugin 'vaaleyard/tmux-dotbar'
      set -g @plugin 'simonkrenn/tmux-palette'

      # tmux-palette
      set -g @palette-runtime 'rust
      set -g @palette-key 'C-p'

      # tmux-dotbar colors (dark theme defaults)
      set -g @tmux-dotbar-bg "#191d21"
      set -g @tmux-dotbar-fg "#45505b"
      set -g @tmux-dotbar-fg-current "#E0E0E0"
      set -g @tmux-dotbar-fg-session "#888888"
      set -g @tmux-dotbar-fg-prefix "#F4457D"

      # Theme switch hooks (source scripts from your config)
      set-hook -g client-dark-theme 'run-shell ${config.xdg.configHome}/tmux/tmux.dark.sh'
      set-hook -g client-light-theme 'run-shell ${config.xdg.configHome}/tmux/tmux.light.sh'

      run '${config.home.homeDirectory}/.tmux/plugins/tpm/tpm'
    '';
  };

}
