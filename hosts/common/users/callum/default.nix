{ config, lib, pkgs, ... }: {
  # Define a user account - platform specific configurations
  users.users = lib.mkMerge [
    # Common settings for both platforms
    {
      callum = {
        description = "Callum";
        shell = pkgs.zsh;
      };
    }

    # Linux-specific settings
    (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      callum = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        initialPassword = lib.mkIf (!config.users.mutableUsers) "password";
      };
    })

    # Darwin-specific settings
    (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
      callum = {
        home = "/Users/callum";
      };
    })
  ];
}

