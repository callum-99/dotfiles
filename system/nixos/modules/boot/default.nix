{ config, lib, hostname, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf optional;
  inherit (lib.types) submodule bool str listOf int;

  cfg = config.module.boot;
in {
  options.module.boot = {
    enable = mkEnableOption "Enables boot";

    canTouchEfiVars = mkOption {
      type = bool;
      default = true;
      description = "Allow touching of efi variables";
    };

    ssh = mkOption {
      type = submodule {
        options = {
          enable = mkOption {
            type = bool;
            default = false;
            description = "Whether to enable ssh at boot";
          };

          ip = mkOption {
            type = str;
            default = "";
            description = "IP address";
          };

          gateway = mkOption {
            type = str;
            default = "";
            description = "Gateway address";
          };

          netmask = mkOption {
            type = str;
            default = "";
            description = "Network mask";
          };

          interface = mkOption {
            type = str;
            default = "";
            description = "Network interface";
          };

          port = mkOption {
            type = int;
            default = 1722;
            description = "Port number";
          };

          authorisedKeys = mkOption {
            type = listOf str;
            default = [ ];
            description = "List of authorized SSH key paths";
          };

          hostKeys = mkOption {
            type = listOf str;
            default = [ ];
            description = "List of host key paths";
          };
        };
      };
      description = "Enable ssh at boot. Need ip, port, authorised keys and host_keys";
      default = {
        enable = false;
        ip = "";
        gateway = "";
        netmask = "";
        interface = "";
        port = 1722;
        authorisedKeys = [ "" ];
        hostKeys = [ "" ];
      };

      example = {
        enable = true;
        ip = "192.168.0.2";
        gateway = "192.168.0.1";
        netmask = "255.255.255.0";
        interface = "wlan0";
        port = 1722;
        authorisedKeys = [ "ssh-..." ];
        hostKeys = [ config.sops."HOST_KEY".path ];
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.ssh.enable -> cfg.ssh.ip != "" ->
                    cfg.ssh.gateway != "" -> cfg.ssh.netmask != "" ->
                    cfg.ssh.interface != "" -> cfg.ssh.authorisedKeys != [ "" ] ->
                    cfg.ssh.hostKeys != [ "" ];
        message = "Please set all the params for initrd ssh";
      }
    ];

    boot = {
      loader = {
        systemd-boot.enable = (!config.module.lanzaboote.enable);
        efi.canTouchEfiVariables = cfg.canTouchEfiVars;
      };

      kernelParams = [] ++ optional cfg.ssh.enable [ "ip=${cfg.ssh.ip}::${cfg.ssh.gateway}:${cfg.ssh.netmask}:${hostname}:${cfg.ssh.interface}:none" ];

      initrd.network.ssh = mkIf cfg.ssh.enable {
        enable = true;
        port = cfg.ssh.port;
        authorizedKeys = cfg.ssh.authorisedKeys;
        hostKeys = cfg.ssh.hostKeys;
      };
    };
  };
}
