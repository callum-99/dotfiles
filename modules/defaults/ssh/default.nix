{ config, lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) listOf str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    ssh = {
      publicKeys = mkOption {
        type = listOf str;
        default = [];
      };
    };
  };
}
