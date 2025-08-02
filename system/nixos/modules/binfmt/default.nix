{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.binfmt;
in {
  options.module.binfmt = {
    enable = mkEnableOption "Enables binfmt";
  };

  config = mkIf cfg.enable {
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
