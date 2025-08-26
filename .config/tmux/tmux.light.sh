echo "switching light"

tmux set -g @nova-nerdfonts false
tmux set -g @nova-nerdfonts-left 
tmux set -g @nova-nerdfonts-right 

tmux set -g @nova-segment-mode "#{?client_prefix,Ω,ω}"
tmux set -g @nova-segment-mode-colors "#6E98EB #fff"

tmux set -g @nova-segment-whoami "#(whoami)@#h"
tmux set -g @nova-segment-whoami-colors "#6E98EB #fff"

tmux set -g @nova-pane "#I#{?pane_in_mode,  #{pane_mode},}  #W"

tmux set -g @nova-rows 0
tmux set -g @nova-segments-0-left "mode"
tmux set -g @nova-segments-0-right "whoami"

tmux set -g @nova-pane-active-border-style "#39ADB5"
tmux set -g @nova-pane-border-style "#e0e0e0"
tmux set -g @nova-status-style-bg "#e0e0e0"
tmux set -g @nova-status-style-active-fg "#e0e0e0" 
tmux set -g @nova-status-style-double-bg "#e0e0e0"
tmux set -g @nova-status-style-active-bg "#ABCF76"

tmux source ~/.tmux.conf
