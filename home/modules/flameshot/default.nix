{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.flameshot;
in {
  options.module.flameshot = {
    enable = mkEnableOption "Enables flameshot";
  };

  config = mkIf cfg.enable {
    services.flameshot = {
      enable = true;

      settings = {
        General = {
          contrastOpacity = 100;
          disabledTrayIcon = true;
          drawColor = "#ff00ff";
          saveAfterCopy = true;
          saveAsFileExtension = "png";
          savePath = "${config.home.homeDirectory}/Pictures/Screenshots";
          showDesktopNotifications = true;
        };

        Shortcuts = {
          TYPE_COPY = "Return";
          TYPE_SAVE = "";
        };
      };
    };
  };
}
