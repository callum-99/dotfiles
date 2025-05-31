{ config, lib, pkgs, inputs, ... }: {
  # Set nix settings
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
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

