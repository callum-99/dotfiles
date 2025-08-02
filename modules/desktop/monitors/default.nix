{ lib, config, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) int enum bool str float either nullOr listOf attrsOf submodule;

  cfg = config.machine.monitors;
in {
  options.machine.monitors = mkOption {
    type = attrsOf (submodule {
      options = {
        width = mkOption {
          type = int;
          example = 2560;
          description = "Monitor width in px";
        };

        height = mkOption {
          type = int;
          example = 1440;
          description = "Monitor height in px";
        };

        refreshRate = mkOption {
          type = int;
          default = 60;
          description = "Monitor refresh rate in Hz";
        };

        variableRefreshRate = mkOption {
          type = enum [ "off" "on" "fullscreen" "games" ];
          default = "off";
          description = ''
            Variable refresh rate support
              - on         # Enabled everywhere
              - off        # Not enabled
              - fullscreen # Enabled for fullscreen programs only
              - games      # Enabled for videos/games only
          '';
        };

        scale = mkOption {
          type = float;
          default = 1.0;
          example = 1.0;
          description = "Monitor scale factor";
        };

        x = mkOption {
          type = int;
          default = 0;
          description = "Monitor x position in px";
        };

        y = mkOption {
          type = int;
          default = 0;
          description = "Monitor y position in px";
        };

        orientation = mkOption {
          type = enum [ "normal" "flipped" "left" "right" ];
          default = "normal";
          example = "normal";
          description = ''
            Monitor rotation orientation
              - normal:  landscape
              - flipped: landscape flipped
              - left:    90 deg counter-clockwise
              - right:   90 deg clockwise
          '';
        };

        enabled = mkOption {
          type = bool;
          default = true;
          description = "Monitor enabled";
        };

        workspaces = mkOption {
          type = nullOr (listOf (either int str));
          default = null;
          example = [ "main" "dev" 6 "web" ];
          description = "Which workspace the monitor is bound to";
        };

        defaultWorkspace = mkOption {
          type = nullOr (either int str);
          default = null;
          example = "dev";
          description = "Which the default workspace is for this monitor";
        };
      };
    });

    default = {};
    description = "Monitor configurations";
  };
}
