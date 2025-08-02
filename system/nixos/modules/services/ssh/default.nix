{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib) zipAttrs;
  inherit (lib.types) attrs listOf;

  cfg = config.module.services.ssh;
in {
  options.module.services.ssh = {
    enable = mkEnableOption "Enable module";

    listenAddresses = lib.mkOption {
      type = listOf attrs;
      default = [ { addr = "0.0.0.0"; port = 22; } ];
      description = "Specify which ports and addresses the SSH daemon listens on";
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = [ 22 ] ++ (zipAttrs cfg.listenAddresses).port;

    services.openssh = {
      inherit (cfg) listenAddresses;

      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = true;
        X11Forwarding = false;
      };
    };
  };
}
