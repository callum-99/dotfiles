{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.shell;
in {
  options.module.shell = {
    enable = mkEnableOption "Enables shell";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        # Additional zsh configuration
        export PATH="$HOME/local/bin:$PATH"

        # Key bindings
        bindkey "^[[3~" delete-char                   # Delete key
        bindkey "^[[H" beginning-of-line              # Home key
        bindkey "^[[F" end-of-line                    # End key
        bindkey "^[[1;5C" forward-word                # Ctrl+Right arrow
        bindkey "^[[1;5D" backward-word               # Ctrl+Left arrow
        bindkey "^[[3;5~" delete-word                 # Ctrl+Delete
        bindkey "^H" backward-delete-word             # Ctrl+Backspace

        autoload -U up-line-or-beginning-search
        autoload -U down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey "^[[A" up-line-or-beginning-search   # Up arrorw
        bindkey "^[OA" up-line-or-beginning-search   # Alt up arrow
        bindkey "^[[B" down-line-or-beginning-search # Down arrow
        bindkey "^[OB" down-line-or-beginning-search # Alt down arrow
      '';

      completionInit = ''
        # Init completion system
        autoload -Uz compinit
        compinit

        # Case insensitive completion
        zstyle ':completion:*' menu select

        # Completion caching
        zstyle ':completion:*' use-cache yes
        zstyle ':completion:*' cache-path ~/.zsh/cache

        # Better completion for kill command
        zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

        # Don't complete uninteresting files
        zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
        zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
        zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
        zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
      '';

      history = {
        size = 10000;
        save = 10000;
        share = true;
        ignoreDups = true;
        ignoreSpace = true;
        extended = true;
      };

      shellAliases = {
        "cd" = "z";
      };
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;

        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
      };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    home.sessionPath = [ "$HOME/.local/bin" ];
  };
}
