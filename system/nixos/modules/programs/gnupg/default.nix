{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.programs.gnupg;
in {
  options.module.programs.gnupg = {
    enable = mkEnableOption "Enables gnupg";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gnupg ];
  };
}
