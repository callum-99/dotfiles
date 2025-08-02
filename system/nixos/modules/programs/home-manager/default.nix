{ config, lib, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  machineConfig = builtins.trace "Machine Config:" config.machine;

  cfg = config.module.programs.home-manager;
in {
  options.module.programs.home-manager = {
    enable = mkEnableOption "Enables home-manager";
  };

  config = mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
