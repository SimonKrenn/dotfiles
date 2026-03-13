echo "switching light"

tmux set-option -g @tmux-dotbar-bg '#ffffff'
tmux set-option -g @tmux-dotbar-fg '#c2c3c5'
tmux set-option -g @tmux-dotbar-fg-current '#313131'
tmux set-option -g @tmux-dotbar-fg-session '#848484'
tmux set-option -g @tmux-dotbar-fg-prefix '#E3329F'

tmux run-shell ~/.tmux/plugins/tmux-dotbar/dotbar.tmux
