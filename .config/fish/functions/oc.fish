function oc --wraps="opencode"
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
end
