{ config, lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    networks = {
      iface = mkOption {
        type = str;
        default = "";
      };

      ip = mkOption {
        types = str;
        default = "";
      };

      gateway = mkOption {
        types = str;
        default = "";
      };

      mask = mkOption {
        type = str;
        default = "";
      };

      cidr = mkOption {
        type = str;
        default = "";
      };

      mac = mkOption {
        type = str;
        default = "";
      };
    };
  };
}
