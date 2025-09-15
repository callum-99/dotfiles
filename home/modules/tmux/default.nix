{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.tmux;
in {
  options.module.tmux = {
    enable = mkEnableOption "Enables tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      escapeTime = 0;
      terminal = "tmux-256color";

      prefix = "C-a";
      extraConfig = ''
        unbind C-b
        bind-key C-a send prefix

        bind | split-window -h
        bind - split-window -v
        unbind "'"
        unbind %

        bind -r ^ last-window
        bind -r k select-pane -U
        bind -r j select-pane -D
        bind -r h select-pane -L
        bind -r k select-pane -R

        bind-key -r f run-shell "tmux neww tmux-sessionizer"

        bind-key -n Home send Escape "[H"
        bind-key -n End  send Escape "[F"
      '';
    };

    home.packages = [
      (pkgs.writeShellApplication {
        name = "tmux-sessionizer";
        runtimeInputs = with pkgs; [ tmux fd zoxide coreutils fzf gawk ];
        text = ''
          switch_to() {
              if [[ -z $TMUX ]]; then
                  tmux attach-session -t "$1"
              else
                  tmux switch-client -t "$1"
              fi
          }

          has_session() {
              tmux list-sessions | grep -q "^$1:"
          }

          hydrate() {
              if [ -f "$2/.tmux-sessionizer" ]; then
                  tmux send-keys -t "$1" "source $2/.tmux-sessionizer" C-m
              elif [ -f "$HOME/.tmux-sessionizer" ]; then
                  tmux send-keys -t "$1" "source $HOME/.tmux-sessionizer" C-m
              fi
          }

          if [[ $# -eq 1 ]]; then
              selected=$1
          else
              selected=$(
                (
                  echo ~/.dotfiles
                  echo /dotfiles
                  fd -td -d2 . ~/Developer
                ) | while read -r p; do
                  zoxide query -l -s "$p"
                done | sort -rnk1 | fzf --no-sort | awk '{print $2}'
              )
          fi

          if [[ -z $selected ]]; then
              exit 0
          fi

          selected_name=$(basename "$selected" | tr . _)
          tmux_running=$(pgrep tmux)

          if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
              tmux new-session -s "$selected_name" -c "$selected"
              hydrate "$selected_name" "$selected"
              exit 0
          fi

          if ! has_session "$selected_name"; then
              tmux new-session -ds "$selected_name" -c "$selected"
              hydrate "$selected_name" "$selected"
          fi

          switch_to "$selected_name"
        '';
      })
    ];
  };
}
