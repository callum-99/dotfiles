{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    backlightControl = mkOption {
      type = enum [
        "light"
        "brightnessctl"
      ];

      default = "light";
    };

    backlightControlCmd = let
      backlightControlExecs = {
        light         = "${pkgs.light}/bin/light";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      };
    in
      mkOption {
        type = str;
        default = backlightControlExecs.${cfg.backlightControl};
      };
  };
}
