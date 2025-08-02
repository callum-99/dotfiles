{ config, pkgs, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.module.neovim;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.treesitter = {
        enable = true;

        settings = {
          ensureInstalled = [
            "bash"
            "c"
            "diff"
            "html"
            "lua"
            "luadoc"
            "markdown"
            "markdown_inline"
            "query"
            "vim"
            "vimdoc"
          ];

          highlight = {
            enable = true;
            additional_vim_regex_highlighting = true;
          };

          indent = {
            enable = true;
            disable = [
              "ruby"
            ];
          };
        };
      };
    };
  };
}
