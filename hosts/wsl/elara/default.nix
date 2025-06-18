{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../../common/global
    ../../common/global/linux.nix
    ../../common/users/callum
    ../../common/users/callum/linux.nix
    ../../common/optional/ssh.nix
  ];

  # Set hostname
  networking.hostName = "elara";

  # Enable networking
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";

  # Titan-specific packages
  environment.systemPackages = with pkgs; [
    wget
    git
    neovim
  ];

  wsl = {
    enable = true;
    defaultUser = "callum";
    startMenuLaunchers = false;
    useWindowsDriver = true;
    wslConf.interop.appendWindowsPath = false;
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}

