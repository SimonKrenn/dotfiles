# command overrides
alias erd="erd -."
alias ls="eza -a -g --icons"
alias lg="lazygit"
alias edit="nvim"
alias browse="yazi"
alias ya="yazi"
alias y="yarn"
alias pn='pnpm'
alias g='git'
alias find='fd'
alias mux='tmuxinator'
alias cat='bat'


# obsidian related
alias oot='sesh connect $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/'
alias oow="cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/work/"
alias oop="cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten/"

# sesh
alias slist='sesh connect $(sesh list --icons | fzf --no-sort --ansi)'
alias slast='sesh last'

# utilities
alias sf='source ~/.config/fish/config.fish'

# yazi
function ya
	set tmp (mktemp -t "yazi-cwd.XXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end  
