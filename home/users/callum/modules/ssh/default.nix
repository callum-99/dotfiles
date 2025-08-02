{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.user.ssh;
in {
  options.module.user.ssh = {
    enable = mkEnableOption "Enables ssh";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
    };
  };
}
