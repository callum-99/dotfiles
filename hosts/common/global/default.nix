{ config, lib, pkgs, inputs, ... }: {
  # Set nix settings
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

  # Set timezone
  time.timeZone = "Europe/London";

  # Enable zsh
  programs.zsh.enable = true;
}

