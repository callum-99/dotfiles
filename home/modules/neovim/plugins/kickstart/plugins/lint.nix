{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.module.neovim;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.lint = {
        enable = true;

        lintersByFt = {
          nix = [ "nix" ];
          markdown = [ "markdownlint" ];
          dockerfile = [ "hadolint" ];
        };

        autoCmd = {
          callback.__raw = ''
            function()
              require('lint').try_lint()
            end
          '';
          group = "lint";
          event = [
            "BufEnter"
            "BufWritePost"
            "InsertLeave"
          ];
        };
      };

      autoGroups = {
        lint = {
          clear = true;
        };
      };
    };
  };
}
