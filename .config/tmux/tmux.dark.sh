tmux tmux set -g @nova-nerdfonts true
tmux tmux set -g @nova-nerdfonts-left 
tmux set -g @nova-nerdfonts-right 

tmux set -g @nova-segment-mode "#{?client_prefix,Ω,ω}"
tmux set -g @nova-segment-mode-colors "#6E98EB #282a36"

tmux set -g @nova-segment-whoami "#(whoami)@#h"
tmux set -g @nova-segment-whoami-colors "#6E98EB #282a36"

tmux set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"

tmux set -g @nova-rows 0
tmux set -g @nova-segments-0-left "mode"
tmux set -g @nova-segments-0-right "whoami"

tmux set -g @nova-pane-active-border-style "#39ADB5"
tmux set -g @nova-pane-border-style "#232537"
tmux set -g @nova-status-style-bg "#0F111A"
tmux set -g @nova-status-style-active-fg "#2e3540" 
tmux set -g @nova-status-style-double-bg "#2d3540"
tmux set -g @nova-status-style-active-bg "#ABCF76"
