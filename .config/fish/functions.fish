function wto --description "Create git worktree and launch opencode session"
  if test (count $argv) -lt 1
    echo "Usage: wto <branch-name>"
    return 1
  end

  set -l branch $argv[1]
  wt switch --create $branch -x opencode
end
