{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.locales;
in {
  options.module.locales = {
    enable = mkEnableOption "Enables locales";
  };

  config = mkIf cfg.enable {
    i18n = {
      defaultLocale = "en_GB.UTF-8";
      supportedLocales = [ "all" ];
    };
  };
}
