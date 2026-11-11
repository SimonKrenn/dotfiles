# command overrides
alias erd="erd -."
alias ls="eza -a -g --icons"
alias edit="nvim"
alias browse="yazi"
alias y="yarn"
alias pn='pnpm'
alias g='git'
alias find='fd'
alias mux='tmuxinator'
alias cat='bat'
alias nv='nvim'
alias oc-list='oc list'

# obsidian related
alias oot='sesh connect $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/'
alias oow="cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/work/"
alias oop="cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten/"

# sesh
alias slist='sesh connect (sesh list --icons | fzf --no-sort --ansi --tmux)'
alias slast='sesh last'

# utilities
alias sf='source ~/.config/fish/config.fish'
