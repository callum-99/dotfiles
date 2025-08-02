{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    browser = mkOption {
      type = enum [
        "firefox"
        "librewolf"
      ];

      default = "firefox";
    };

    browserCmd = let
      browserExecs = {
        firefox   = "${pkgs.firefox}/bin/firefox";
        librewolf = "${pkgs.librewolf}/bin/librewolf";
      };
    in
      mkOption {
        type = str;
        default = browserExecs.${cfg.browser};
      };
  };
}
