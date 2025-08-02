{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf optionalAttrs;

  cfg = config.module.security;
in {
  options.module.security = {
    enable = mkEnableOption "Enables security";
    enableBootOptions = mkEnableOption "Enable boot flags";
  };

  config = mkIf cfg.enable {
    security = {
      sudo.enable = false;

      pam.services = {
        hyprlock = {};
      };

      sudo-rs = {
        enable = true;
        execWheelOnly = true;
        wheelNeedsPassword = true;
      };
    };

    boot = optionalAttrs cfg.enableBootOptions {
      kernelParams = [
        "debugfs=off"
        "page_alloc.shuffle=1"
        "page_poison=1"
        "slab_nomerge"
        "oops=panic"
      ];

      blacklistedKernelModules = [
        "appletalk"
        "decnet"

        "ax25"
        "netrom"
        "rose"

        "adfs"
        "affs"
        "bfs"
        "befs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "freevxfs"
        "f2fs"
        "hfs"
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"
        "ufs"
      ];

      kernel.sysctl = {
        # Hide kernel pointers for processes with CAP_SYSLOG
        "kernel.kptr_restrict" = 2;

        # Disable ftrace debugging
        "kernel.frtace_enabled" = false;

        # Enable strict reverse path filtering
        "net.ipv4.conf.all.log_martians" = true;
        "net.ipv4.conf.all.rp_filter" = "1";
        "net.ipv4.conf.default.log_martians" = true;
        "net.ipv4.conf.default.rp_filter" = "1";

        # Ignore broadcast pings
        "net.ipv4.icmp_echo_ignore_broadcasts" = true;

        # Ignore incoming ping redirects
        "net.ipv4.conf.all.accept_redirects" = false;
        "net.ipv4.conf.all.secure_redirects" = false;
        "net.ipv4.conf.default.accept_redirects" = false;
        "net.ipv4.conf.default.secure_redirects" = false;
        "net.ipv6.conf.all.accept_redirects" = false;
        "net.ipv6.conf.default.accept_redirects" = false;

        # Ignore outgoing ping redirects
        "net.ipv4.conf.all.send_redirects" = false;
        "net.ipv4.conf.default.send_redirects" = false;
      };
    };
  };
}
