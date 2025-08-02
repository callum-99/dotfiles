{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.module.neovim;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.indent-blankline = {
        enable = true;
      };
    };
  };
}
