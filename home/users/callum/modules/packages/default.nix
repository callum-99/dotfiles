{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.user.packages;
in {
  options.module.user.packages = {
    enable = mkEnableOption "Enables home packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      bat
      ncdu
      bottom
      btop
      du-dust
    ];
  };
}
