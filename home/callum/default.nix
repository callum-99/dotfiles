{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ./global
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
    fonts = {
      serif = {
        package = pkgs.roboto-slab;
        name = "Roboto Slab";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.fira-code;
        name = "Fira Code Nerd Font";
      };

      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "Fira Code Nerd Font";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}

