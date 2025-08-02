{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.sound;
in {
  options.module.sound = {
    enable = mkEnableOption "Enables sound";
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;

      pulse.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
  };
}
