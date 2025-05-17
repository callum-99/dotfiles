{ config, lib, pkgs, inputs, ... }: {
  # Common configuration for all systems

  # Set nix settings
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
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

  # Set environment variables
  environment = {
    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # System packages common to all systems
    systemPackages = with pkgs; [
      curl
      git
      wget
      vim
      htop
    ];
  };

  # Set timezone and locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable zsh
  programs.zsh.enable = true;
}

