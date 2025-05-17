{ config, lib, pkgs, ... }: {
  # Define a user account
  users.users.callum = {
    isNormalUser = true;
    description = "Callum";
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;

    # For NixOS systems
    initialPassword = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux && !config.users.mutableUsers) "password";

    # For Darwin systems
    home = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin "/Users/callum";
  };

  # Allow sudo without password for this user
  security.sudo.extraRules = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
    {
      users = [ "callum" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}

