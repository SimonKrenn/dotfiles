#!/bin/bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_dir"

if [[ $# -eq 0 ]]; then
  set -- list
fi

command="$1"
shift
case "$command" in
  add)
    # Codex uses the universal ~/.agents/skills directory. Mise links that
    # directory and OpenCode's skill directory back to this repository.
    set -- add --global --agent codex "$@"
    ;;
  update | upgrade)
    set -- "$command" --global --yes "$@"
    ;;
  list | ls | remove | rm)
    set -- "$command" --global "$@"
    ;;
esac

exec mise exec -- skills "$@"
