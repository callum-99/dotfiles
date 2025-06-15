{ config, inputs, pkgs, lib, helpers, ... }:
let
  inherit (config) monitors;

  enabledMonitors = lib.filter (m: m.enabled) monitors;

  monitorConfigs = lib.forEach enabledMonitors (m: let
    resolution = if m ? width && m ? height && m ? refreshRate then
      "${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz"
    else
     "preferred";

    position = if m ? x && m ? y then
      "${toString m.x}x${toString m.y}"
    else
     "auto";

    scale = if m ? scale then helpers.stripTrailingZeros m.scale else "auto";
  in
    "${m.name},${resolution},${position},${scale}"
  );
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      monitor = monitorConfigs;

      input = {
        kb_layout = "gb";
      };

      env = [
        "GDK_SCALE,2"
        "XCURSOR_SIZE,32"
      ];

      xwayland.force_zero_scaling = true;

      bind = [
        "$mod, F, exec, firefox"
        "$mod, Return, exec, wezterm"
        "$mod SHIFT, Return, exec, rofi -show drun"

        "$mod Shift, Q, killactive"
      ] ++ (
          builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
        9)
      );
    };
  };
}
