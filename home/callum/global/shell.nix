{ config, lib, pkgs, ... }: {
  # Configure zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "kubectl" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      ll = "ls -la";
      cd = "z";
    };

    initContent = ''
      # Additional zsh configuration
      export PATH="$HOME/.local/bin:$PATH"
    '';
  };

  # Configure starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      # Add more starship configuration here
    };
  };

  # Configure fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}

