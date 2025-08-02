{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.emacs;
in {
  options.module.emacs = {
    enable = mkEnableOption "Enables emacs";
  };

  config = mkIf cfg.enable {
    programs.emacs = {
      enable = true;
    };

    services.emacs = {
      enable = true;
    };
  };
}
