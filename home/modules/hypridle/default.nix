{ lib, config, inputs, pkgs, hostname, hyprlandEnable, ... }:
let
  inherit (lib) mkEnableOption mkIf optionals;

  cfg = config.module.hypridle;

  suspendCmd  = "${pkgs.systemd}/bin/systemctl suspend";
  hyprctlCmd  = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl";
  hyprlockCmd = "${config.programs.hyprlock.package}/bin/hyprlock";

  hyprlandOnScreen  = "${hyprctlCmd} dispatch dpms on";
  hyprlandOffScreen = "${hyprctlCmd} dispatch dpms off";
  screenOn          = if hyprlandEnable then hyprlandOnScreen else "";
  screenOff         = if hyprlandEnable then hyprlandOffScreen else "";
in {
  options.module.hypridle = {
    enable = mkEnableOption "Enables hypridle";
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "${hyprlockCmd}";
          unlock_cmd = "";
          before_sleep_cmd = "${hyprlockCmd}";
          after_sleep_cmd = "";
          ignore_dbus_inhibit = false;
        };

        listener = [
          {
            timeout = 300;
            on-timeout = screenOff;
            on-resume = screenOn;
          }
          {
            timeout = 600;
            on-timeout = hyprlockCmd;
            on-resume = "";
          }
        ] ++ optionals (hostname == "phobos") [
          {
            timeout = 7200;
            on-timeout = suspendCmd;
            on-resume = "";
          }
        ];
      };
    };
  };
}
