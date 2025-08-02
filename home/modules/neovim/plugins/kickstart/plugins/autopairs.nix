{ config, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = config.module.neovim;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.nvim-autopairs = {
        enable = true;
      };

      extraConfigLua = ''
        require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done())
      '';
    };
  };
}
