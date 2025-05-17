{ config, lib, pkgs, ... }: {
  # SOPS configuration for home-manager
  sops = {
    # Age configuration
    age = {
      # Generate a key if it doesn't exist
      generateKey = true;
      # Key file location - user specific
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };

    # Default sops file
    defaultSopsFile = ../../secrets/secrets.yaml;
  };

  # Ensure the directory for the age key exists
  home.activation.sopsKeyDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d "${config.home.homeDirectory}/.config/sops/age" ]; then
      $DRY_RUN_CMD mkdir -p "${config.home.homeDirectory}/.config/sops/age"
      $DRY_RUN_CMD chmod 700 "${config.home.homeDirectory}/.config/sops/age"
    fi
  '';
}
