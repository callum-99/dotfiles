{ pkgs, lib, self, config, hostname, theme, stateVersion, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf optionalAttrs;
  inherit (lib.types) bool;

  cfg = config.module.stylix;

  cursorSize = if hostname == "phobos" then 48 else 24;
 
  fontSize = if hostname == "dione" then 16 else 12;

  themes = {
    gruvbox-dark = {
      scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

      wallpaper = pkgs.fetchurl {
        url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/media/branch/master/svg/gruvbox-dark-rainbow.svg";
        hash = "sha256-T0Ge2n5UW/yBLeeSH7io/GF4IZshv4Vv6qXVtswgcvE=";
      };

      font = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };

      cursor = {
        package = pkgs.apple-cursor;
        name = "macOS";
      };
    };

    gruvbox-light = {
      scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-hard.yaml";

      wallpaper = pkgs.fetchurl {
        url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/media/branch/master/svg/gruvbox-light-rainbow.svg";
        hash = "sha256-nDWCghOIfjBm+Dd+XxauWpTVNkTDfTnU8jRhvrL90kY=";
      };

      font = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font Mono";
      };

      cursor = {
        package = pkgs.apple-cursor;
        name = "macOS";
      };
    };
  };
in {
  options.module.stylix = {
    enable = mkEnableOption "Enables Stylix";

    useCursor = mkOption {
      type = bool;
      default = false;
      description = "Enable the custom cursor";
    };
  };

  config = {
    stylix = {
      enable = true;
      image = themes.${theme}.wallpaper;
      autoEnable = true;
      polarity = "dark";
      base16Scheme = themes.${theme}.scheme;

      opacity = {
        applications = 1.0;
        terminal = 0.8;
        popups = 0.8;
        desktop = 1.0;
      };

      fonts = {
        sizes = {
          applications = fontSize;
          desktop = fontSize;
          popups = fontSize;
          terminal = fontSize;
        };

        serif = {
          inherit (themes.${theme}.font) package name;
        };

        sansSerif = config.stylix.fonts.serif;
        monospace = config.stylix.fonts.serif;

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    } // optionalAttrs cfg.useCursor {
      cursor = {
        inherit (themes.${theme}.cursor) package name;
        size = cursorSize;
      };
    };
  };
}
