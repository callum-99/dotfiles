{ config, lib, isWorkstation, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf optionals;

  cfg = config.module.programs.systemPackages;
in {
  options.module.programs.systemPackages = {
    enable = mkEnableOption "Enables system software";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts-color-emoji
    ];

    environment.systemPackages = with pkgs; [
      # Utils
      git
      curl
      wget
      zip
      unzip
      jq
      file

      # Hardware utils
      lm_sensors
      pciutils
      usbutils
      powertop
      lsof
      sbctl
      cpufetch
      strace
      ltrace
      sysstat

      # Network utils
      inetutils
      wireguard-tools
      doggo
      dig
      nmap
      dnsutils
    ] ++ optionals isWorkstation [
        # Hardware
        libGL

        # Hardware utils
        fwupd
        fwupd-efi

        # Utils
        dconf-editor
    ];
  };
}
