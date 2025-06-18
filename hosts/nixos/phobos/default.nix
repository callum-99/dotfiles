{ config, lib, pkgs, inputs, ... }:
let
  appleFirmware = pkgs.fetchzip {
    url = "http://172.16.19.1:42069/macbook-air.zip";
    sha256 = "sha256-PNM021D6ykv/JpBwVrc7um6H/MqyGPVGjTmrFvnlbvo=";
  };
in {
  imports = [
    ./hardware-configuration.nix
    ../../common/global
    ../../common/global/linux.nix
    ../../common/users/callum
    ../../common/users/callum/linux.nix
    ../../common/optional/ssh.nix

    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  hardware.asahi = {
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    setupAsahiSound = true;
    peripheralFirmwareDirectory = appleFirmware;
    extractPeripheralFirmware = true;
  };

  # Set hostname
  networking.hostName = "phobos";

  # Enable networking
  networking.wireless.enable = false; # Disable wpa_supplicant
  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };

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

  i18n.defaultLocale = "en_GB.UTF-8";

  # Phobos-specific packages
  environment.systemPackages = with pkgs; [
    wget
    git
    neovim
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";
}

