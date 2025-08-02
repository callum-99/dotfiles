{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.wezterm;
in {
  options.module.wezterm = {
    enable = mkEnableOption "Enables wezterm";
  };

  config = mkIf cfg.enable {
    programs.wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
