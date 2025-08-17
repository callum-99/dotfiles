{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.user.ssh;
in {
  options.module.user.ssh = {
    enable = mkEnableOption "Enables ssh";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;

      includes = [ "extraHosts" ];

      matchBlocks = {
        "*" = {
          setEnv = {
            "TERM" = "xterm-256color";
          };
        };

        horus = {
          port = 1722;
        };

        anubis = {
          port = 1722;
        };

        thunder1 = {
          hostname = "100.64.0.8";
        };

        thunder2 = {
          hostname = "100.64.0.9";
        };

        truenas = {
          port = 1722;
          user = "admin";
          hostname = "100.64.0.6";
        };
      };
    };
  };
}
