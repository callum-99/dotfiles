{ config, lib, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-surround
      vim-commentary
      nvim-treesitter
      telescope-nvim
      lualine-nvim
      nvim-lspconfig
      nvim-cmp
    ];

    extraConfig = ''
      set number
      set relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set smartindent
      set termguicolors
    '';
  };
}

