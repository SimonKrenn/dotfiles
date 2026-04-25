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
alias nv='nvim'
alias oc='opencode'

# obsidian related
alias oot='sesh connect $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/'
alias oow="cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/work/"
alias oop="cd $HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/zettelkasten/"

# sesh
alias slist='sesh connect $(sesh list --icons | fzf --no-sort --ansi --tmux)'
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

function oc-list
    set -l sessions (oc session list --format json | jq -r '.[] | [.id,.title,.directory] | @tsv')
    set -l selected (printf '%s\n' $sessions | fzf --delimiter="\t" --height=40% --popup center)
    set -l id (echo $selected | awk '{print $1}')
  
    if test -z "$id"
      return
    end

    oc -s $id
  
end

# function oc-projects
#   set -l projects (oc db 'select worktree from project' --format json | jq -r '.[] |[.worktree] | @tsv')
#   set -l selected (printf '%s\n' $projects | fzf --delimiter="\t" --popup center)
#   set -l project_path (echo $selected | awk '{print $1}')
#
#   # if test -z "$project_path"
#   #   return
#   # end
#
#   echo $project_path
# end
#

