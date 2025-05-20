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

  # SOPS configuration
  sops = {
    secrets = {
    };
  };
}

