{ config, lib, pkgs, inputs, ... }: {
  # SOPS configuration for NixOS
  sops = {
    # Age configuration
    age = {
      # Generate a key if it doesn't exist
      generateKey = true;
      # Key file location - system specific
      keyFile = "/var/lib/sops-nix/key.txt";
      # Alternatively, derive from SSH key
      #sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    };

    # Default sops file
    defaultSopsFile = ../../secrets/secrets.yaml;

    # Secrets to be created
    secrets = {
    };
  };

  # Ensure the directory for the age key exists
  system.activationScripts.sopsKeyDir = lib.mkIf pkgs.stdenv.isLinux ''
    if [ ! -d /var/lib/sops-nix ]; then
      mkdir -p /var/lib/sops-nix
      chmod 700 /var/lib/sops-nix
    fi
  '';
}

