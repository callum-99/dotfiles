{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.services.udev;
in {
  options.module.services.udev = {
    enable = mkEnableOption "Enables udev";
  };

  config = mkIf cfg.enable {
    services.udev.extraRules = ''
    '';
  };
}
