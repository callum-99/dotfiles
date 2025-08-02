{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    terminal = mkOption {
      type = enum [
        "wezterm"
        "kity"
        "alacritty"
      ];
      default = "wezterm";
    };

    terminalCmd = let
      terminalExecs = {
        wezterm = "${pkgs.wezterm}/bin/wezterm";
        kitty = "${pkgs.kitty}/bin/kitty";
        alacritty = "${pkgs.alacritty}/bin/alacritty";
      };
    in mkOption {
      type = str;
      default = terminalExecs.${cfg.terminal};
    };
  };
}
