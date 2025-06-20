{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ./global
    ../modules
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = "callum";
    homeDirectory = if pkgs.stdenv.hostPlatform.isDarwin
                    then "/Users/callum"
                    else "/home/callum";

    # This value determines the Home Manager release that your configuration is compatible with
    stateVersion = "25.05";
  };

  # Enable flakes and nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Setup stylix
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    image = pkgs.fetchurl {
      url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/media/branch/master/png/gruvbox-dark-rainbow.png";
      hash = "sha256-7CMuETntiVUCKhUIdJzX+sf3F47GvuX2a61o4xbEzww";
    };

    fonts = {
      sizes = {
        applications = 12;
        desktop = 12;
        popups = 12;
        terminal = 16;
      };

      serif = {
        package = pkgs.roboto-slab;
        name = "Roboto Slab";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };

    opacity = {
      applications = 1.0;
      desktop = 0.7;
      popups = 0.7;
      terminal = 0.8;
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}

