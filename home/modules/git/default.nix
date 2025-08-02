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
      userName = "Callum Yarnold";
      userEmail = "git@yarnold.co.uk";

      signing = {
        format = "ssh";
        key = "~/.ssh/id_rsa.pub";
        signByDefault = true;
      };

      extraConfig = {
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
    };
  };
}
