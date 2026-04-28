fish_add_path /opt/homebrew/bin
starship init fish | source
zoxide init fish --cmd cd| source
direnv hook fish | source
op completion fish | source
fzf --fish | source
atuin init fish | source
# global Aliases

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

if [ -f $HOME/.config/fish/alias.fish ]
	source $HOME/.config/fish//alias.fish
end

# work aliases 
if [ -f $HOME/.config/fish/private-alias.fish ]
	source $HOME/.config/fish/private-alias.fish
end

# functions
if [ -f $HOME/.config/fish/functions.fish ]
source $HOME/.config/fish/functions.fish
end

# path 
set PATH /Users/int004977/.local/share/bob/nvim-bin/ $PATH

# bun
# set --export BUN_INSTALL "$HOME/.bun"
# set --export PATH $BUN_INSTALL/bin $PATH
fzf_configure_bindings --directory=\cf --variables=\cv

# env vars
set -q XDG_CONFIG_HOME || set -Ux XDG_CONFIG_HOME $HOME/.config
set -q XDG_HOME || set -Ux XDG_HOME $HOME
set -q EDITOR || set -Ux EDITOR nvim
set -q VISUAL || set -Ux VISUAL nvim

# Created by `pipx` on 2025-04-21 18:22:51
set PATH $PATH /Users/int004977/.local/bin

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/int004977/.lmstudio/bin
# End of LM Studio CLI section



# amp
fish_add_path "~/.local/bin"
fish_add_path $HOME/.local/bin

# Added by git-ai installer on Tue Mar  3 13:31:21 CET 2026
fish_add_path -g "/Users/int004977/.git-ai/bin"

# global bun executables 
fish_add_path "/Users/simonkrenn/.bun/bin"


# Added by git-ai installer on Fri Mar 13 17:11:34 CET 2026
fish_add_path -g "/Users/simonkrenn/.git-ai/bin"

fish_add_path -g "/Users/simonkrenn/.browser-use/bin"
fish_add_path -g "/Users/simonkrenn/.browser-use-env/bin"

##colors
set -g fish_color_command 53A1FA
set -g fish_color_param 5BD1B9
set -g fish_color_quote f9c35a
set -g fish_color_error F44747
set -g fish_color_keyword B267E6
set -g fish_color_option 53A1FA
set -g fish_color_valid_path --underline


