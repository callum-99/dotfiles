{ config, lib, pkgs, inputs, ... }: {
  # Set nix settings
  nix = {
    optimise = {
      automatic = true;
      interval = [
        {
          Hour = 18;
          Minute = 0;
          Weekday = 1;
        }
      ];
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };

    # Garbage collection
    gc = {
      automatic = true;
      interval = [
        {
          Hour = 18;
          Minute = 0;
          Weekday = 1;
        }
      ];
      options = "--delete-older-than 30d";
    };
  };
}

