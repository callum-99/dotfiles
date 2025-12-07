{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    appLauncher = mkOption {
      type = enum [
        "rofi"
        "fuzzel"
      ];

      default = "rofi-wayland";
    };

    appLauncherCmd = let
      appLauncherExecs = {
        rofi         = "${pkgs.rofi}/bin/rofi -show drun";
        fuzzel       = "${pkgs.fuzzel}/bin/fuzzel --show drun";
      };
    in
      mkOption {
        type = str;
        default = appLauncherExecs.${cfg.appLauncher};
      };
  };
}
