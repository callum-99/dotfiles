{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../default.nix
    ../features/dev
    ../features/cli
    ../features/linux
    ../features/desktop/hyprland
    ../features/desktop/apps/emacs
  ];

  home.packages = with pkgs; [
    git
    zsh
  ];

  workspaces = {
    "main" = {
      id = 1;
    };

    "dev" = {
      id = 2;
      windowRules = [
        { class = "^org.wezfurlong.wezterm$"; }
        { class = "^Emacs$"; }
        { class = "^code$"; }
      ];
    };

    "web" = {
      id = 3;
      windowRules = [
        { class = "^firefox$"; }
      ];
    };

    "music" = {
      id = 4;
      windowRules = [
        { class = "^feishin$"; }
        { class = "^Spotify$"; }
      ];
    };
  };

  monitors = {
    "eDP-1" = {
      width = 2560;
      height = 1600;
      scale = 1.667;
      refreshRate = 60;
      workspaces = [ "main" "dev" "web" "music" 5 6 7 8 9 ];
      defaultWorkspace = "main";
    };
  };

  # SOPS configuration
  sops = {
    secrets = {
    };
  };
}

