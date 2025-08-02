{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.dconf;
in {
  options.module.dconf = {
    enable = mkEnableOption "Enables dconf";
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    };
  };
}
