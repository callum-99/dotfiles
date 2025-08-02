{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf mkDefault;

  cfg = config.module.minimal;
in {
  options.module.minimal = {
    enable = mkEnableOption "Enables a minimal config";
  };

  config = mkIf cfg.enable {
    documentation = {
      enable = mkDefault false;
      doc.enable = mkDefault false;
      info.enable = mkDefault false;
      man.enable = mkDefault false;
      nixos.enable = mkDefault false;
    };

    services.logrotate.enable = mkDefault false;
    programs.command-not-found.enable = mkDefault false;
  };
}
