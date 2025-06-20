{ config, lib, pkgs, inputs, ... }: {
  # Set nix settings
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;

      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  services.dbus.enable = true;
  environment.systemPackages = with pkgs; [
    dconf
  ];
}

