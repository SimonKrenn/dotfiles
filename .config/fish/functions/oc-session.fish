function oc-select 
  set -l (oc-session list --format json  jq -r '.[] | [.id, .title] | @tsv')
  echo $sessions | fzf
end
