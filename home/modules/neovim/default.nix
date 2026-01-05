{ config, lib, pkgs, self, waylandEnable, xorgEnable, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.neovim;
in {
  imports = [ "${self}/home/modules/neovim/plugins" ];

  options.module.neovim = {
    enable = mkEnableOption "Enables neovim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      globals = {
        mapleader = " ";
        maplocalleader = " ";
        have_nerd_font = true;
      };

      clipboard = {
        providers = {
          wl-copy.enable = waylandEnable;
          xsel.enable = xorgEnable;
        };
        register = "unnamedplus";
      };

      opts = {
        number = true;
        relativenumber = true;
        mouse = "a";
        showmode = false;
        breakindent = true;
        undofile = true;
        ignorecase = true;
        smartcase = true;
        signcolumn = "yes";
        updatetime = 250;
        timeoutlen = 300;
        splitright = true;
        splitbelow = true;
        list = false;
        listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
        inccommand = "split";
        cursorline = true;
        scrolloff = 10;
        confirm = true;
        hlsearch = true;
        tabstop = 2;
        shiftwidth = 2;
      };

      keymaps = [
        {
          mode = "n";
          key = "<Esc>";
          action = "<cmd>nohlsearch<CR>";
        }
        {
          mode = "t";
          key = "<Esc><Esc>";
          action = "<C-\\><C-n>";
          options = {
            desc = "Exit terminal mode";
          };
        }
        {
          mode = "n";
          key = "<C-h>";
          action = "<C-w><C-h>";
          options = {
            desc = "Move focus to the left window";
          };
        }
        {
          mode = "n";
          key = "<C-l>";
          action = "<C-w><C-l>";
          options = {
            desc = "Move focus to the right window";
          };
        }
        {
          mode = "n";
          key = "<C-j>";
          action = "<C-w><C-j>";
          options = {
            desc = "Move focus to the lower window";
          };
        }
        {
          mode = "n";
          key = "<C-k>";
          action = "<C-w><C-k>";
          options = {
            desc = "Move focus to the upper window";
          };
        }
        {
          mode = "n";
          key = "<leader>tl";
          action = "<cmd>set list!<CR>";
          options = {
            desc = "Toggle list chars";
          };
        }
      ];

      autoGroups = {
        kickstart-highlight-yank = {
          clear = true;
        };
      };

      autoCmd = [
        {
          event = [ "TextYankPost" ];
          desc = "Highlight when yanking (copying) text";
          group = "kickstart-highlight-yank";
          callback.__raw = ''
            function()
              vim.highlight.on_yank()
            end
          '';
        }
      ];

      plugins = {
        web-devicons.enable = true;
        sleuth.enable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [
        nvim-web-devicons
      ];

      extraConfigLuaPost = ''
        -- vim: ts=2 sts=2 sw=2 et
      '';
    };

    stylix.targets.nixvim = {
      enable = true;
      transparentBackground.main = false;
      transparentBackground.numberLine = false;
      transparentBackground.signColumn = false;
    };
  };
}

