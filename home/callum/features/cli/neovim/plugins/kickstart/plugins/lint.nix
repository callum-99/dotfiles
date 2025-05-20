{
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
}
