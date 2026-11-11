# Stable system tools must be available before mise activation.
fish_add_path --path $HOME/.bun/bin $HOME/.git-ai/bin $HOME/.browser-use/bin $HOME/.browser-use-env/bin $HOME/.lmstudio/bin
fish_add_path --path --move /opt/homebrew/bin /opt/homebrew/sbin $HOME/.local/bin

set -q XDG_CONFIG_HOME; or set -Ux XDG_CONFIG_HOME $HOME/.config
set -q XDG_HOME; or set -Ux XDG_HOME $HOME
set -q EDITOR; or set -Ux EDITOR nvim
set -q VISUAL; or set -Ux VISUAL nvim

function __onehunter_sync_fzf_colors --on-variable fish_terminal_color_theme
  set -l theme unknown
  if test "$ONEHUNTER_APPEARANCE" = dark -o "$ONEHUNTER_APPEARANCE" = light
    set theme $ONEHUNTER_APPEARANCE
  else if set -q fish_terminal_color_theme
    set theme $fish_terminal_color_theme
  end

  switch $theme
    case dark
      set -gx FZF_DEFAULT_OPTS "--color=bg+:#34393E,bg:#191d21,spinner:#5BD1B9,hl:#53A1FA --color=fg:#E0E0E0,header:#F4457D,info:#B267E6,pointer:#5BD1B9 --color=marker:#53A1FA,fg+:#E6E6E6,prompt:#B267E6,hl+:#F4457D --color=selected-bg:#34393E --color=border:#45505b,label:#E0E0E0"
    case light
      set -gx FZF_DEFAULT_OPTS "--color=bg+:#E6E6E6,bg:#ffffff,spinner:#0BA463,hl:#0488DB --color=fg:#313131,header:#E1239A,info:#B267E6,pointer:#0BA463 --color=marker:#0488DB,fg+:#212121,prompt:#B267E6,hl+:#E1239A --color=selected-bg:#E6E6E6 --color=border:#ADADAD,label:#313131"
  end
end

__onehunter_sync_fzf_colors

if status is-interactive
  if type -q mise; and not functions -q __mise_env_eval
    mise activate fish | source
  end

  for tool in starship zoxide direnv op fzf atuin
    if not type -q $tool
      continue
    end
    switch $tool
      case starship
        starship init fish | source
      case zoxide
        zoxide init fish --cmd cd | source
      case direnv
        direnv hook fish | source
      case op
        op completion fish | source
      case fzf
        fzf --fish | source
      case atuin
        atuin init fish | source
    end
  end

  source $XDG_CONFIG_HOME/fish/alias.fish
  source $XDG_CONFIG_HOME/fish/functions.fish

  if functions -q fzf_configure_bindings
    fzf_configure_bindings --directory=\cf --variables=\cv
  end

  set -g fish_color_command 53A1FA
  set -g fish_color_param 5BD1B9
  set -g fish_color_quote f9c35a
  set -g fish_color_error F44747
  set -g fish_color_keyword B267E6
  set -g fish_color_option 53A1FA
  set -g fish_color_valid_path --underline

  # Local overrides run last and are never deployed from Git.
  for local_file in private-alias.fish local.fish
    if test -f $XDG_CONFIG_HOME/fish/$local_file
      source $XDG_CONFIG_HOME/fish/$local_file
    end
  end
end
