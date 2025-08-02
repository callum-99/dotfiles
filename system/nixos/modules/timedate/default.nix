{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.timedate;
in {
  options.module.timedate = {
    enable = mkEnableOption "Enables timedate";
  };

  config = mkIf cfg.enable {
    time.timeZone = "Europe/London";
    services.ntpd-rs.enable = true;
  };
}
