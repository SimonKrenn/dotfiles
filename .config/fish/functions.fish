function wto --description "Create git worktree and launch opencode session"
  if test (count $argv) -lt 1
    echo "Usage: wto <branch-name>"
    return 1
  end

  set -l branch $argv[1]
  wt switch --create $branch -x opencode
end


function oc --wraps opencode
  if test (count $argv) -gt 0
    switch $argv[1]
      case list
        set -l sessions (oc session list --format json | jq -r '.[] | [.id,.title,.directory] | @tsv')
        set -l selected (printf '%s\n' $sessions | fzf --delimiter="\t" --height=40% --popup center)
        set -l id (echo $selected | awk '{print $1}')
  
        if test -z "$id"
          return
        end

        opencode -s $id
        return
    end
  end

  command opencode $argv
end
