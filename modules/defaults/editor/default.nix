{ config, lib, pkgs, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) enum str;

  cfg = config.module.defaults;
in {
  options.module.defaults = {
    editor = mkOption {
      type = enum [
        "neovim"
        "emacs"
        "helix"
        "vscode"
      ];

      default = "neovim";
    };

    editorCmd = let
      editorExecs = {
        neovim = "${pkgs.neovim}/bin/neovim";
        emacs  = "${pkgs.emacs}/bin/emacs";
        helix  = "${pkgs.helix}/bin/helix";
        vscode = "${pkgs.vscode}/bin/vscode";
      };
    in mkOption {
      type = str;
      default = editorExecs.${cfg.editor};
    };
  };
}
