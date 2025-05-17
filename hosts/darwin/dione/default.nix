{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../../common/global
    ../../common/users/callum
  ];

  # Set hostname
  networking.hostName = "dione";

  # macOS system settings
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
    dock = {
      autohide = true;
      orientation = "right";
      showhidden = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      ShowPathbar = true;
    };
  };

  # Enable fonts
  fonts.fontDir.enable = true;

  # Enable homebrew
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
    ];
  };

  # Darwin-specific packages
  environment.systemPackages = with pkgs; [
    coreutils
    gnupg
    wget
  ];

  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  # Used for backwards compatibility
  system.stateVersion = 4;
}

