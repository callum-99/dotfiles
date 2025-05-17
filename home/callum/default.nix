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

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}

