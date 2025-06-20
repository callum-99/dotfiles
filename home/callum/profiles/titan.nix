{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../default.nix
    ../features/dev
    ../features/cli
    ../features/linux
    ../features/desktop/hyprland
    ../features/desktop/apps/wezterm
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
    "DP-3" = {
      width = 2560;
      height = 1440;
      y = -1440;
      refreshRate = 60;
      orientation = "flipped";
      workspaces = [ "web" "music" ];
      defaultWorkspace = "web";
    };

    "DP-4" = {
      width = 2560;
      height = 1440;
      refreshRate = 165;
      variableRefreshRate = "on";
      workspaces = [ "main" "dev" 5 6 7 8 9 ];
      defaultWorkspace = "main";
    };
  };

  # SOPS configuration
  sops = {
    secrets = {
    };
  };
}

