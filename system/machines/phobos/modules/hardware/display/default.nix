{ config, ... }: {
  config.machine = {
    monitors = {
      "eDP-1" = {
        width = 2560;
        height = 1600;
        scale = 1.6666;
        workspaces = [ "main" "dev" "web" "nusic" 5 6 7 8 9 ];
        defaultWorkspace = "main";
      };
    };

    workspaces = {
      "main" = {
        id = 1;
      };

      "dev" = {
        id = 2;
        windowRules = [
          { class = "^org.wezterm.wezterm$"; }
          { class = "^Emacs$"; }
          { class = "^code$"; }
        ];
      };

      "web" = {
        id = 3;
        windowRules = [
          { class = "^firefox$"; }
          { class = "^librewolf$"; }
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
  };
}
