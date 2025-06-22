{ config, pkgs, ... }: {
  programs.tmux = {
    enable = true;

    escapeTime = 0;
    terminal = "tmux-256color";

    extraConfig = ''
      # Split window bindings
      bind | split-window -h
      bind - split-window -v
      unbind "'"
      unbind %

      # Vim-like window switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      # Tmux sessioniser binding
      bind-key -r f run-shell "tmux neww tmux-sessioniser"
    '';
  };

  # Create the tmux-sessioniser script
  home.packages = with pkgs; [
    (writeShellScriptBin "tmux-sessioniser" ''
      #!/usr/bin/env bash
      switch_to() {
          if [[ -z $TMUX ]]; then
              tmux attach-session -t $1
          else
              tmux switch-client -t $1
          fi
      }

      has_session() {
          tmux list-sessions | grep -q "^$1:"
      }

      hydrate() {
          if [ -f $2/.tmux-sessioniser ]; then
              tmux send-keys -t $1 "source $2/.tmux-sessioniser" C-m
          elif [ -f $HOME/.tmux-sessioniser ]; then
              tmux send-keys -t $1 "source $HOME/.tmux-sessioniser" C-m
          fi
      }

      if [[ $# -eq 1 ]]; then
          selected=$1
      else
          selected=$(
            (
              echo /dotfiles
              ${fd}/bin/fd -td -d2 . $DEVELOPER
            ) | while read -r p; do 
              ${zoxide}/bin/zoxide query -l -s "$p"
            done | sort -rnk1 | ${fzf}/bin/fzf --no-sort | awk '{print $2}'
          )
      fi

      if [[ -z $selected ]]; then
          exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)
      tmux_running=$(pgrep tmux)

      if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
          tmux new-session -s $selected_name -c $selected
          hydrate $selected_name $selected
          exit 0
      fi

      if ! has_session $selected_name; then
          tmux new-session -ds $selected_name -c $selected
          hydrate $selected_name $selected
      fi

      switch_to $selected_name
    '')
    fd
    fzf
    zoxide
  ];
}
