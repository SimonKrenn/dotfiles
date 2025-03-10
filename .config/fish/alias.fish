# command overrides
alias erd="erd -."
alias ls="eza -a"
alias lg="lazygit"
alias edit="nvim"
alias browse="yazi"
alias ya="yazi"
alias y="yarn"
alias pn='pnpm'
alias g='git'
alias find='fd'
alias mux='tmuxinator'
function ya
	set tmp (mktemp -t "yazi-cwd.XXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		cd -- "$cwd"
	end
	rm -f -- "$tmp"
end  
