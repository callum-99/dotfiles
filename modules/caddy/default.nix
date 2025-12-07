{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf mapAttrs' nameValuePair optionalString mkMerge concatLists concatMap;
  inherit (lib.types) str submodule port attrsOf bool nullOr listOf;

  cfg = config.module.services.caddy;

  proxy = submodule {
    options = {
      upstream = mkOption {
        type = str;
        default = "localhost";
        example = "localhost";
        description = "Upstream service host/ip";
      };

      port = mkOption {
        type = port;
        example = 3000;
        description = "Upstream service port";
      };

      useHttps = mkOption {
        type = bool;
        default = false;
        description = "Use HTTPS for the upstream connection";
      };

      extraConfig = mkOption {
        type = str;
        default = "";
        example = ''
          header_down -Server
          timeout 30s
        '';
        description = "Extra configuration";
      };
    };
  };

  host = submodule {
    options = {
      root = mkOption {
        type = str;
        example = "/var/www/website";
        description = "Document root";
      };

      extraConfig = mkOption {
        type = str;
        default = "";
        example = ''
          try_files {path} {path}/ /index.html
        '';
        description = "Extra configuration";
      };
    };
  };
in {
  options.module.services.caddy = {
    enable = mkEnableOption "Enables caddy";

    hostURI = mkOption {
      type = str;
      example = "example.com";
      description = "Base domain for all routes, proxies and certificates";
    };

    useStagingServer = mkOption {
      type = bool;
      default = false;
      description = "Use lets encrypt staging server for testing";
    };

    additionalDomainNames = mkOption {
      type = nullOr listOf str;
      default = null;
      example = [ "example.com" "example.net" ];
      description = "Additional domain names to get certificates for (not hostURI)";
    };

    proxies = attrsOf proxy;
    hosts = attrsOf host;
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.hostURI != "";
        message = "hostURI cannot be empty";
      }
      {
        assertion = builtins.all (proxy: proxy.upstream != "") (builtins.attrValues cfg.proxies);
        message = "All proxy hosts must be non-empty";
      }
      {
        assertion = builtins.all (host: host.root != "") (builtins.attrValues cfg.hosts);
        message = "All static hosts must have non-empty host and root";
      }
    ];

    services.caddy = {
      enable = true;

      virtualHosts = mapAttrs' (name: proxy: nameValuePair "${name}.${cfg.hostURI}" {
        extraConfig = ''
          encode zstd gzip
          reverse_proxy ${if proxy.useHttps then "https" else "http"}://${proxy.upstream}:${toString proxy.port} {
            header_up X-Real-IP {remote_host}
            ${optionalString proxy.useHttps ''
              transport http {
                tls_insecure_skip_verify
              }
            ''}
            ${proxy.extraConfig}
          }
        '';
      }) cfg.proxies
      // mapAttrs' (name: host: nameValuePair "${name}.${cfg.hostURI}" {
        extraConfig = ''
          root * ${host.root}
          encode zstd gzip
          ${host.extraConfig}
          file_server
        '';
      }) cfg.hosts;

      extraConfig = ''
        tls /var/lib/acme/${cfg.hostURI}/fullchain.pem /var/lib/acme/${cfg.hostURI}/key.pem
      '';
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    security.acme = {
      acceptTerms = true;
      defaults.email = config.sops.secrets.ACME_EMAIL;
      defaults.dnsProvider = config.sops.secrets.ACME_PROVIDER;
      defaults.environmentFile = config.sops.templates.ACME_ENV.path;
      server = mkIf cfg.useStagingServer "https://acme-staging-v02.api.letsencrypt.org/directory";
      dnsPropagationCheck = true;
      certs."${cfg.hostURI}" = {
        extraDomainNames = concatLists [
          [ "*.${cfg.hostURI}" ]
          (concatMap (domain: [ domain "*.${domain}" ]) (cfg.additionalDomainNames or []))
        ];
        group = config.users.groups.acme.name;
        postRun = ''
          umask 077

          openssl pkcs12 -export \
            -in /var/lib/acme/${cfg.hostURI}/fullchain.pem \
            -inkey /var/lib/acme/${cfg.hostURI}/key.pem \
            -out /var/lib/acme/${cfg.hostURI}/cert.pfx \
            -passout pass:${config.sops.secrets.ACME_PFX_PASSWORD}

            chown root:${config.users.groups.acme.name} /var/lib/acme/${cfg.hostURI}/cert.pfx

            chmod 640 /var/lib/acme/${cfg.hostURI}/cert.pfx
        '';
      };
    };

    users.groups.acme = mkMerge [
      (config.users.groups.acme or {})
      {}
    ];

    users.caddy.extraGroups = (config.users.caddy.extraGroups or []) ++ [ "acme" ];

    sops = {
      secrets = {
        ACME_EMAIL = {};
        ACME_PROVIDER = {};
        ACME_PROVIDER_TOKEN = {};
        ACME_PFX_PASSWORD = {};
      };
      templates.ACME_ENV.content = ''
        ${config.sops.placeholder.ACME_PROVIDER_TOKEN}
      '';
    };
  };
}
