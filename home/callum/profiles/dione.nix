{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../default.nix
    ../features/darwin
    ../features/dev
    ../features/cli
    ../features/desktop/apps/wezterm
    ../features/desktop/apps/emacs
  ];

  home.packages = with pkgs; [
    git
    zsh
    coreutils
    gnupg
  ];

  home.sessionPath = [
    "$HOME/.swiftly/bin"
  ];

  # SOPS configuration
  sops = {
    secrets = {
    };
  };
}

