{
  perSystem = { pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      name = "flake-template";
      meta.description = "DevShell for flake";

      # Env
      EDITOR = "${pkgs.neovim}/bin/nvim";

      packages = with pkgs; [
        vim
        git
        curl
        zsh
        tmux
        ripgrep
        htop
        fzf
        just
        sops
        age
        nixfmt-rfc-style
        nil
      ];
    };
  };
}
