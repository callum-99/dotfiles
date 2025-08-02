{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    clipboardHistoryCmd = let
      clipboardHistoryBase = "${pkgs.cliphist}/bin/cliphist";
      createExec = launcher: "${clipboardHistoryBase} list | ${launcher} | ${clipboardHistoryBase} decode | ${pkgs.wl-clipboard}/bin/wl-copy";

      clipboardHistoryExecs = {
        rofi         = createExec "${pkgs.rofi}/bin/rofi -dmeny";
        rofi-wayland = createExec "${pkgs.rofi-wayland}/bin/rofi -dmenu";
        fuzzel       = createExec "${pkgs.fuzzel}/bin/fuzzel -d";
      };
    in
      mkOption {
        type = str;
        default = clipboardHistoryExecs.${cfg.appLauncher};
      };
  };
}
