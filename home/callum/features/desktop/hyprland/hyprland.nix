{ config, inputs, pkgs, lib, helpers, ... }:
let
  inherit (config) monitors workspaces;

  enabledMonitors = lib.filterAttrs (name: m: m.enabled) monitors;

  monitorConfigs = lib.mapAttrsToList (monitorName: m:
    let
      resolution = if m ? width && m ? height && m ? refreshRate then
        "${toString m.width}x${toString m.height}@${toString m.refreshRate}Hz"
      else
       "preferred";

      position = if m ? x && m ? y then
        "${toString m.x}x${toString m.y}"
      else
       "auto";

      scale = if m ? scale then helpers.stripTrailingZeros m.scale else "auto";

      orientation = if m ? orientation then
        toString ({ normal = 0; right = 1; flipped = 2; left = 3; }.${m.orientation})
      else
        "0";

      vrr = if m ? variableRefreshRate then
        toString ({ off = 0; on = 1; fullscreen = 2; games = 3; }.${m.variableRefreshRate})
      else
        "0";
    in
      "${monitorName}, ${resolution}, ${position}, ${scale}, transform, ${orientation}, vrr, ${vrr}"
  ) enabledMonitors;

  nameToId = lib.mapAttrs (name: ws: ws.id) workspaces;

  resolveWorkspace = ref:
    if nameToId ? ${toString ref}
    then nameToId.${toString ref}
    else ref;

  workspaceRules = lib.flatten (lib.mapAttrsToList (monitorName: monitor:
    lib.optionals (monitor.workspaces != null) (
      lib.forEach monitor.workspaces (workspace:
        let
          resolvedWorkspace = toString (resolveWorkspace workspace);
          workspaceIdentifier = if nameToId ? ${toString workspace}
                                then "name:${workspace}"
                                else toString resolvedWorkspace;
          isDefault = monitor.defaultWorkspace != null && (toString (resolveWorkspace monitor.defaultWorkspace)) == resolvedWorkspace;
          defaultSuffix = if isDefault then ", default:true" else "";
        in
          "${workspaceIdentifier}, monitor:${monitorName}${defaultSuffix}"
      )
    )
  ) enabledMonitors);

  windowRules = lib.flatten (lib.mapAttrsToList (wsName: ws:
    lib.forEach ws.windowRules (rule:
      let
        conditions = lib.concatStringsSep "," (lib.mapAttrsToList (key: value:
          "${key}:${value}"
        ) rule);

      in
        "workspace name:${wsName}, ${conditions}"
    )
  ) workspaces);
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      monitor = monitorConfigs;
      workspace = workspaceRules;
      windowrulev2 = windowRules;

      exec-once = "${pkgs.waybar}/bin/waybar";

      input = {
        kb_layout = "gb";
      };

      env = [
        "GDK_SCALE,1"
        "XCURSOR_SIZE,32"
      ];

      xwayland.force_zero_scaling = true;

      cursor.no_hardware_cursors = true;

      bind = [
        "$mod, F, exec, firefox"
        "$mod, Return, exec, wezterm"
        "$mod SHIFT, Return, exec, rofi -show drun"

        "$mod Shift, Q, killactive"
      ] ++ (
          builtins.concatLists (builtins.genList (i:
            let
              ws = i + 1;

              # check if workspace has a name
              name = lib.findFirst
                (wsData: wsData.value.id == ws)
                null
                (lib.mapAttrsToList (name: value: { inherit name value; }) workspaces);
              workspaceRef = if name != null
                             then "name:${name.name}"
                             else toString ws;
            in [
              "$mod, code:1${toString i}, workspace, ${workspaceRef}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${workspaceRef}"
            ]
          )
        9)
      );

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
