{ config, lib, pkgs, ... }: {
  imports = [
    ./git.nix
    ./neovim
    ./tmux.nix
  ];

  # CLI-specific packages
  home.packages = with pkgs; [
    bat
    eza
    zoxide
    du-dust
    bottom
    tldr
    ncdu
  ];
}

