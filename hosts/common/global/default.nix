{ config, lib, pkgs, inputs, ... }:
let
  hostname = config.networking.hostName;
  sshSecretsFile = ../../secrets/machines/${hostname}/ssh.yaml;
  machineSecretsFile = ../../secrets/machines/${hostname}/secrets.yaml;
  homePath = (if lib.isDarwin then "/Users/" else "/home/") ++ config.users.users.callum.name;
in {
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
      just
    ];
  };

  # Set timezone
  time.timeZone = "Europe/London";

  # Enable zsh
  programs.zsh.enable = true;

  #sops = {
  #  defaultSopsFile = ../../../secrets/secrets.yaml;
  #  #age.keyFile = "/var/lib/sops-nix/key.txt";

  #  secrets = {
  #    "ssh_private_key_ed25519" = {
  #      sopsFile = ../../secrets/machines/elara/ssh.yaml;
  #      path = "${homePath}/.ssh/id_ed25519";
  #      owner = config.users.users.callum.name;
  #      group = config.users.users.callum.group;
  #      mode = "0600";
  #    };
  #    "ssh_public_key_ed25519" = {
  #      sopsFile = ../../secrets/machines/elara/ssh.yaml;
  #      path = "${homePath}/.ssh/id_ed25519.pub";
  #      owner = config.users.users.callum.name;
  #      group = config.users.users.callum.group;
  #      mode = "0644";
  #    };
  #  };
  #};
}

