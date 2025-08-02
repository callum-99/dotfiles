{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    notificationsApp = mkOption {
      type = enum [
        "swaync"
        "mako"
      ];

      default = "swaync";
    };

    notificationsAppCmd = let
      notificationsAppExecs = {
        swaync     = "${pkgs.light}/bin/swaync-client -t -sw";
        mako       = "${pkgs.brightnessctl}/bin/mako ";
      };
    in
      mkOption {
        type = str;
        default = notificationsAppExecs.${cfg.notificationsApp};
      };
  };
}
