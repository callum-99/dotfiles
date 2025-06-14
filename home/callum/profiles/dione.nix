{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../default.nix
    ../features/dev
    ../features/cli
    ../features/linux
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

