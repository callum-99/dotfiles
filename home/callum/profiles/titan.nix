{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../default.nix
    ../features/dev
    ../features/linux
  ];

  home.packages = with pkgs; [
    git
    zsh
  ];

  # SOPS configuration
  sops = {
    secrets = {
    };
  };
}

