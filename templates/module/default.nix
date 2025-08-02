{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.name;
in {
  options.module.name = {
    enable = mkEnableOption "Enables name";
  };

  config = mkIf cfg.enable {
  };
}
