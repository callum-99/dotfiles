{ ... }: {
  programs.waybar = {
    enable = true;

    settings = [
      {
        layer = "top";
        position = "top";
        mod = "dock";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        height = 0;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [
          "tray"
          "network"
          "clock"
        ];

        "hyprland/window" = { format = "{}"; };
        "wlr/workspaces" = {
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          all-outputs = true;
          on-click = "activate";
        };

        tray = {
          icon-size = 13;
          tooltip = false;
          spacing = 10;
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>
          '';
        };

        network = {
          format = "󰈁";
          format-disconnected = "󰈂";
        };
      }
    ];
  };
}
