{ config, lib, pkgs, inputs, ... }:
let
  hostname = config.networking.hostName;
  sshSecretsFile = ../../secrets/machines/${hostname}/ssh.yaml;
  machineSecretsFile = ../../secrets/machines/${hostname}/secrets.yaml;
  homePath = (if pkgs.stdenv.isDarwin then "/Users/" else "/home/") + config.users.users.callum.name;
in {
  # SOPS configuration for NixOS
  sops = {
    # Age configuration
    age = {
      generateKey = true;
      keyFile = "/var/lib/sops-nix/key.txt";
    };

    # Global secrets
    defaultSopsFile = ../../secrets/global/secrets.yaml;

    # Secrets configuration
    secrets = {

    }
    # SSH keys (if SSH secrets file exists)
    // lib.optionalAttrs (builtins.pathExists sshSecretsFile) {
      "ssh_private_key_ed25519" = {
        sopsFile = sshSecretsFile;
        owner = "callum";
        path = "${homePath}/.ssh/id_ed25519";
        mode = "0600";
      };

      "ssh_public_key_ed25519" = {
        sopsFile = sshSecretsFile;
        owner = "callum";
        path = "${homePath}/.ssh/id_ed25519.pub";
        mode = "0644";
      };

      # RSA key if it exists in the file
      "ssh_private_key_rsa" = {
        sopsFile = sshSecretsFile;
        owner = "callum";
        path = "${homePath}/.ssh/id_rsa";
        mode = "0600";
      };

      "ssh_public_key_rsa" = {
        sopsFile = sshSecretsFile;
        owner = "callum";
        path = "${homePath}/.ssh/id_rsa.pub";
        mode = "0644";
      };
    }
    # Machine-specific secrets (if machine secrets file exists)
    // lib.optionalAttrs (builtins.pathExists machineSecretsFile) {

    };
  };

  # Ensure SSH directory exists with correct permissions
  system.activationScripts.sshDir = lib.mkIf pkgs.stdenv.isLinux ''
    if [ ! -d /home/callum/.ssh ]; then
      mkdir -p /home/callum/.ssh
      chown callum:users /home/callum/.ssh
      chmod 700 /home/callum/.ssh
    fi
  '';

  # Ensure the directory for the age key exists
  system.activationScripts.sopsKeyDir = lib.mkIf pkgs.stdenv.isLinux ''
    if [ ! -d /var/lib/sops-nix ]; then
      mkdir -p /var/lib/sops-nix
      chmod 700 /var/lib/sops-nix
    fi
  '';
}
