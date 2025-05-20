{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;

      settings = {
        signs = {
          add =          { text = "+"; };
          change =       { text = "~"; };
          delete =       { text = "_"; };
          topdelete =    { text = "‾"; };
          changedelete = { text = "~"; };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "]c";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              require('gitsigns').nav_hunk 'next'
            end
          end
        '';
        options = {
          desc = "Jump to next git [c]hange";
        };
      }
      
      {
        mode = "n";
        key = "[c";
        action.__raw = ''
          function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              require('gitsigns').nav_hunk 'prev'
            end
          end
        '';
        options = {
          desc = "Jump to previous git [c]hange";
        };
      }

      {
        mode = "v";
        key = "<leder>hs";
        action.__raw = ''
          function()
            require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
        '';
        options = {
          desc = "git [s]tage hunk";
        };
      }

      {
        mode = "v";
        key = "<leder>hr";
        action.__raw = ''
          function()
            require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
          end
        '';
        options = {
          desc = "git [r]eset hunk";
        };
      }

      {
        mode = "n";
        key = "<leder>hs";
        action.__raw = ''
          function()
            require('gitsigns').stage_hunk()
          end
        '';
        options = {
          desc = "git [s]tage hunk";
        };
      }

      {
        mode = "n";
        key = "<leder>hr";
        action.__raw = ''
          function()
            require('gitsigns').reset_hunk()
          end
        '';
        options = {
          desc = "git [r]eset hunk";
        };
      }
      
      {
        mode = "n";
        key = "<leder>hS";
        action.__raw = ''
          function()
            require('gitsigns').stage_buffer()
          end
        '';
        options = {
          desc = "git [S]tage buffer";
        };
      }

      {
        mode = "n";
        key = "<leder>hu";
        action.__raw = ''
          function()
            require('gitsigns').undo_stage_hunk()
          end
        '';
        options = {
          desc = "git [u]ndo stage hunk";
        };
      }

      {
        mode = "n";
        key = "<leder>hR";
        action.__raw = ''
          function()
            require('gitsigns').reset_buffer()
          end
        '';
        options = {
          desc = "git [R]eset buffer";
        };
      }

      {
        mode = "n";
        key = "<leder>hp";
        action.__raw = ''
          function()
            require('gitsigns').preview_hunk()
          end
        '';
        options = {
          desc = "git [p]review hunk";
        };
      }

      {
        mode = "n";
        key = "<leder>hb";
        action.__raw = ''
          function()
            require('gitsigns').blame_line()
          end
        '';
        options = {
          desc = "git [b]lame line";
        };
      }

      {
        mode = "n";
        key = "<leder>hd";
        action.__raw = ''
          function()
            require('gitsigns').diff_this()
          end
        '';
        options = {
          desc = "git [d]iff against index";
        };
      }

      {
        mode = "n";
        key = "<leder>hD";
        action.__raw = ''
          function()
            require('gitsigns').diffthis '@'
          end
        '';
        options = {
          desc = "git [d]iff against last commit";
        };
      }

      {
        mode = "n";
        key = "<leder>tb";
        action.__raw = ''
          function()
            require('gitsigns').toggle_current_line_blame()
          end
        '';
        options = {
          desc = "[T]oggle git show [b]lame line";
        };
      }

      {
        mode = "n";
        key = "<leder>tD";
        action.__raw = ''
          function()
            require('gitsigns').toggle_deleted()
          end
        '';
        options = {
          desc = "[T]oggle git show [D]eleted";
        };
      }
    ];
  };
}
