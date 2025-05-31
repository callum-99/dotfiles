{ config, lib, pkgs, inputs, ... }: {
  programs.ssh = {
    enable = true;

    # SSH client configuration
    extraConfig = ''
      # Security settings
      HostKeyAlgorithms ssh-ed25519,ssh-rsa
      PubkeyAuthentication yes
      PasswordAuthentication no
      ChallengeResponseAuthentication no

      # Connection settings
      ServerAliveInterval 60
      ServerAliveCountMax 3

      # Compression
      Compression yes
    '';

    # Host-specific configurations
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };

      "git.truenas.home.yarnold.co.uk" = {
        hostname = "git.truenas.home.yarnold.co.uk";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}
