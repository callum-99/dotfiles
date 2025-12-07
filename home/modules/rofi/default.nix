{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkForce;
  inherit (config.lib.formats.rasi) mkLiteral;
  inherit (config.lib.stylix.colors.withHashtag) base00 base01 base05 base0A base0D;

  cfg = config.module.rofi;
in {
  options.module.rofi = {
    enable = mkEnableOption "Enables rofi";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi;
      cycle = false;
      theme = mkForce {
        "*" = {
          font = "FiraCode Nerd Font Medium 10";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "${base05}";

          margin = mkLiteral "0";
          padding = mkLiteral "0";
          spacing = mkLiteral "0";
        };

        window = {
          location = mkLiteral "center";
          width = 480;
          background-color = mkLiteral "${base00}";
        };

        inputbar = {
          spacing = mkLiteral "8px";
          padding = mkLiteral "8px";
          background-color = mkLiteral "${base01}";
        };

        "prompt, entry, element-icon, element-text" = {
          vertical-align = mkLiteral "0.5";
        };

        prompt = {
          text-color = mkLiteral "${base0D}"; # accent-color mapped to blue
        };

        textbox = {
          padding = mkLiteral "8px";
          background-color = mkLiteral "${base01}";
        };

        listview = {
          padding = mkLiteral "4px 0";
          lines = 8;
          columns = 1;
          fixed-height = false;
        };

        element = {
          padding = mkLiteral "8px";
          spacing = mkLiteral "8px";
        };

        "element normal normal" = {
          text-color = mkLiteral "${base05}";
        };

        "element normal urgent" = {
          text-color = mkLiteral "${base0A}"; # urgent-color mapped to yellow
        };

        "element normal active" = {
          text-color = mkLiteral "${base0D}"; # accent-color mapped to blue
        };

        "element alternate active" = {
          text-color = mkLiteral "${base0D}"; # accent-color mapped to blue
        };

        "element selected" = {
          text-color = mkLiteral "${base00}";
        };

        "element selected normal, element selected active" = {
          background-color = mkLiteral "${base0D}"; # accent-color mapped to blue
        };

        "element selected urgent" = {
          background-color = mkLiteral "${base0A}"; # urgent-color mapped to yellow
        };

        "element-icon" = {
          size = mkLiteral "0.8em";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
        };
      };
    };
  };
}
