{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../common/global
    ../../common/global/linux.nix
    ../../common/users/callum
    ../../common/optional/ssh.nix
  ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set hostname
  networking.hostName = "titan";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable graphics
  hardware.graphics = {
    enable = true;
  };

  # Enable nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    open = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  # Titan-specific packages
  environment.systemPackages = with pkgs; [
    wget
    git
    neovim
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}

