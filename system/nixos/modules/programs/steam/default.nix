{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.programs.steam;
in {
  options.module.programs.steam = {
    enable = mkEnableOption "Enables steam";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    programs.gamemode.enable = true;
  };
}
