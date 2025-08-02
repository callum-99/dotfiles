{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.variables;
in {
  options.module.variables = {
    enable = mkEnableOption "Enables variables";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      NIXPKGS_ALLOW_UNFREE = 1;
    };

    environment.sessionVariables = {
      FLAKE = "/dotfiles";
      };
  };
}
