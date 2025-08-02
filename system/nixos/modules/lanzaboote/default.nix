{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf mkForce;
  inherit (lib.types) bool;

  cfg = config.module.lanzaboote;
in {
  options.module.lanzaboote = {
    enable = mkEnableOption "Enables lanzaboote";

    canTouchEfiVariables = mkOption {
      type = bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    boot = {
      loader.systemd-boot.enable = mkForce false;
      loader.efi.canTouchEfiVariables = cfg.canTouchEfiVariables;

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
}
