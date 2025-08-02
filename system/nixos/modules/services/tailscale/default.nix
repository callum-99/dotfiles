{ lib, pkgs, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib.types) str bool nullOr listOf;

  cfg = config.module.services.tailscale;
in {
  options.module.services.tailscale = {
    enable = mkEnableOption "Enable module";

    authKeyFile = mkOption {
      type = str;
      description = "A path to the tailscale auth key";
    };

    loginServer = mkOption {
      type = str;
      default = "";
      description = "The url to a custom login server";
    };

    advertiseExitNode = mkOption {
      type = bool;
      default = false;
      description = "Wether to advertise this node as an exit node";
    };

    exitNode = mkOption {
      type = str;
      default = "";
      description = "The node to use as an exit node";
    };

    exitNodeAllowLanAccess = mkOption {
      type = bool;
      default = false;
      description = "Wether to allow lan access to this node";
    };

    advertiseRoutes = mkOption {
      type = nullOr (listOf str);
      default = null;
      description = "A list of routes to advertise in CIDR notation";
    };

    acceptDNS = mkOption {
      type = bool;
      default = false;
      description = "Wether to use the tailnet dns server";
    };

    ssh = mkOption {
      type = bool;
      default = false;
      description = "Wether to enable the tailscale ssh server";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.authKeyFile != null; message = "authKeyFile must be set"; }
      { assertion = cfg.exitNodeAllowLanAccess -> cfg.exitNode != ""; message = "exitNodeAllowLanAccess must be false if exitNode is not set"; }
      { assertion = cfg.advertiseExitNode -> cfg.exitNode == ""; message = "advertiseExitNode must be false if exitNode is set"; }
      { assertion = cfg.advertiseRoutes != null -> cfg.exitNode == ""; message = "cant advertise routes if exitNode is set"; }
    ];

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to tailscale";

      # Make sure tailscale is running before we try and connect
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";

      script = with pkgs; ''
        # Wait for tailscaled to settle
        sleep 2

        # Check if we are already connected
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ status = "Running" ]; then
          exit 0;
        fi

        # Authenticate
        # Timeout after 10secs to avoid hanging the boot process
        ${coreutils}/bin/timeout 10 ${tailscale}/bin/tailscale up --reset \
          ${lib.optionalString (cfg.loginServer != "") "--login-server=$(cat \"${cfg.loginServer}\")"} \
          --auth-key=$(cat "${cfg.authKeyFile}") \
          --hostname="${config.networking.hostName}" \
          ${lib.optionalString (cfg.acceptDNS) "--accept-dns"} \
          ${lib.optionalString (cfg.advertiseRoutes != null) "--advertise-routes ${builtins.concatStringsSep "," cfg.advertiseRoutes}"} \
          ${lib.optionalString (cfg.advertiseExitNode) "--advertise-exit-node"} \
          ${lib.optionalString (cfg.exitNode != "") "--exit-node=${cfg.exitNode}"} \
          ${lib.optionalString (cfg.exitNodeAllowLanAccess) "--exit-node-allow-lan-access"} \
          ${lib.optionalString (cfg.ssh) "--ssh"}
      '';
    };

    boot.kernel.sysctl = mkIf (cfg.advertiseRoutes != null || cfg.advertiseExitNode) {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv6.conf.default.forwarding" = 1;
    };

    networking.firewall = {
      trustedInterfaces = [ config.services.tailscale.interfaceName ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    services.tailscale = {
      enable = true;
      useRoutingFeatures = if cfg.advertiseExitNode then "server" else "client";
    };
  };
}
