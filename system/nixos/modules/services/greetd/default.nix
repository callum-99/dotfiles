{ config, lib, username, pkgs, inputs, wm, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.services.greetd;

  wms = {
    hyprland = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland";
  };

  wmCmd = wms.${wm};
in {
  options.module.services.greetd = {
    enable = mkEnableOption "Enables greetd";
  };

  config = mkIf cfg.enable {
    security.pam.services.greetd = {
      enableGnomeKeyring = true;
    };

    programs.regreet = {
      enable = true;
      cageArgs = [
        "-s"
        "-m"
        "last"
      ];
    };

    services.greetd = {
      enable = true;

      vt = 7;

      settings = {
        default_session = {
          user = username;

          command = builtins.concatStringsSep " " [
            "${pkgs.greetd.tuigreet}/bin/tuigreet"
            "--asterisks"
            "--remember"
            "--time"
            "--cmd \"${wmCmd}\""
          ];
        };
      };
    };
  };
}
