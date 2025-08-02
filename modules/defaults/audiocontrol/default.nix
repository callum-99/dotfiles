{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    audioControlCmd = mkOption {
        type = str;
        default = "${pkgs.wpctl}/bin/wpctl";
      };
  };
}
