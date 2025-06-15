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

  monitors = [
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
      refreshRate = 165;
    }
    {
      name = "DP-4";
      width = 2560;
      height = 1440;
      y = 1440;
    }
  ];

  # SOPS configuration
  sops = {
    secrets = {
    };
  };
}

