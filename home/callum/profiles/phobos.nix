{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../default.nix
    ../features/dev
    ../features/cli
    ../features/linux
    ../features/desktop/hyprland
  ];

  home.packages = with pkgs; [
    git
    zsh
  ];

  # Monitor configuration
  monitors = [
    {
      name = "eDP-1";
      width = 2560;
      height = 1600;
      scale = 1.2;
    }
  ];

  # SOPS configuration
  sops = {
    secrets = {
    };
  };
}

