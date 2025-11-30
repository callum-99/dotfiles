{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.git;
in {
  options.module.git = {
    enable = mkEnableOption "Enables git";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "Callum Yarnold";
          email = "git@yarnold.co.uk";
        };

        pull.rebase = true;
        push.autoSetupRemote = true;
      };

      signing = {
        format = "ssh";
        key = "~/.ssh/id_rsa.pub";
        signByDefault = true;
      };
    };
  };
}
