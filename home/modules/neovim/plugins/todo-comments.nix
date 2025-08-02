{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.module.neovim;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.todo-comments = {
        enable = true;
        settings = {
          signs = true;
        };
      };
    };
  };
}
