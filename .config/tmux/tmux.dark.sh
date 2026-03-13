echo "switching dark"

tmux set-option -g @tmux-dotbar-bg '#191d21'
tmux set-option -g @tmux-dotbar-fg '#45505b'
tmux set-option -g @tmux-dotbar-fg-current '#E0E0E0'
tmux set-option -g @tmux-dotbar-fg-session '#888888'
tmux set-option -g @tmux-dotbar-fg-prefix '#F4457D'
tmux run-shell ~/.tmux/plugins/tmux-dotbar/dotbar.tmux
