# Trial config: keep legacy Stow/Home Manager sources unchanged.
set -q XDG_CONFIG_HOME || set -Ux XDG_CONFIG_HOME $HOME/.config
set -q EDITOR || set -Ux EDITOR nvim
set -q VISUAL || set -Ux VISUAL nvim
fish_add_path /opt/homebrew/bin /usr/local/bin
fish_add_path $HOME/.local/bin $HOME/.local/share/bob/nvim-bin
fish_add_path $HOME/.bun/bin $HOME/.git-ai/bin
fish_add_path $HOME/.browser-use/bin $HOME/.browser-use-env/bin

if status is-interactive
  if type -q mise
    mise activate fish | source
  end
  if type -q starship
    starship init fish | source
  end
  if type -q zoxide
    zoxide init fish --cmd cd | source
  end
  if type -q direnv
    direnv hook fish | source
  end
  if type -q op
    op completion fish | source
  end
  if type -q fzf
    fzf --fish | source
  end
  if type -q atuin
    atuin init fish | source
  end
  for file in alias.fish functions.fish private-alias.fish local.fish
    if test -f $XDG_CONFIG_HOME/fish/$file
      source $XDG_CONFIG_HOME/fish/$file
    end
  end
  if functions -q fzf_configure_bindings
    fzf_configure_bindings --directory=\cf --variables=\cv
  end
end

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

set -g fish_color_command 53A1FA
set -g fish_color_param 5BD1B9
set -g fish_color_quote f9c35a
set -g fish_color_error F44747
set -g fish_color_keyword B267E6
set -g fish_color_option 53A1FA
set -g fish_color_valid_path --underline
