{ config, lib, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption optionals;
  inherit (lib.types) bool submodule enum;

  cfg = config.module.virtualisation;
in {
  options.module.virtualisation = {
    enable = mkEnableOption "Enables virtualisation";

    distrobox = mkOption {
      type = submodule {
        options = {
          enable = mkOption { type = bool; };
          backend = mkOption { type = enum [ "podman" "docker" ]; };
        };
      };
      default = { enable = false; backend = "podman"; };
      description = "Enables distrobox";
    };

    virtManager = mkOption {
      type = bool;
      default = false;
      description = "Enables virt-manager and libvirtd";
    };

    docker = mkOption {
      type = bool;
      default = false;
      description = "Enables docker";
    };

    podman = mkOption {
      type = submodule {
        options = {
          enable = mkOption { type = bool; };
          dockerCompat = mkOption { type = bool; };
        };
      };
      default = { enable = false; dockerCompat = true; };
      description = "Enables podman";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.podman.dockerCompat -> !cfg.docker; message = "Docker can't be enabled when podman.dockerCompat is enabled"; }
    ];

    environment.systemPackages =        []
      ++ optionals cfg.docker           [ pkgs.docker-compose ]
      ++ optionals cfg.podman.enable    [ pkgs.podman-compose ]
      ++ optionals cfg.distrobox.enable [ pkgs.distrobox ]
      ++ optionals cfg.virtManager      [ pkgs.virt-manager ];

    virtualisation = {
      docker.enable = cfg.docker || (cfg.distrobox.backend == "docker");

      podman = {
        enable = cfg.podman.enable || (cfg.distrobox.backend == "podman");
        dockerCompat = cfg.podman.dockerCompat;
      };

      libvirtd.enable = cfg.virtManager;
    };
  };
}
