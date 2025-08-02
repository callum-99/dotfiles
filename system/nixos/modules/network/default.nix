{ config, lib, hostname, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption mkDefault mkForce;
  inherit (lib.types) bool;

  cfg = config.module.network;
in {
  options.module.network = {
    enable = mkEnableOption "Enables network";

    hasWireless = mkOption {
      type = bool;
      description = "Wether machine has wifi";
      default = false;
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      network.enable = !cfg.hasWireless;

      services = {
        systemd-networkd-wait-online.enable = mkForce false;
        NetworkManager-wait-online.enable = false;
      };
    };

    networking = {
      firewall.enable = true;

      networkmanager = {
        enable = cfg.hasWireless;
        wifi.macAddress = "random";
        wifi.backend = "iwd";
      };

      wireless.iwd = mkIf cfg.hasWireless {
        enable = true;

        settings = {
          Settings.AutoConnect = true;
        };
      };

      useDHCP = mkDefault true;
      useNetworkd = mkDefault (!cfg.hasWireless);
      hostName = hostname;
    };
  };
}
