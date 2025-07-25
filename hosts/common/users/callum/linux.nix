{ config, lib, pkgs, ... }: {
  users.users.callum = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "podman" "dotfiles" ];
    hashedPasswordFile = config.sops.secrets."USER_PASSWORD".path;
    subGidRanges = [ { count = 65536; startGid = 10000; } ];
    subUidRanges = [ { count = 65536; startUid = 10000; } ];
  };

  users.users.root.hashedPasswordFile = config.sops.secrets."ROOT_PASSWORD".path;

  users.groups.dotfiles = {};
  users.mutableUsers = false;

  sops.secrets = {
    "USER_PASSWORD" = {
      sopsFile = ../../../../secrets/machines/${config.networking.hostName}/secrets.yaml;
      neededForUsers = true;
    };
    "ROOT_PASSWORD" = {
      sopsFile = ../../../../secrets/machines/${config.networking.hostName}/secrets.yaml;
      neededForUsers = true;
    };
  };

  systemd.tmpfiles.rules = [
    "d /dotfiles 0775 callum dotfiles -"
  ];

  system.activationScripts.dotfilesPermissions = {
    text = ''
      # Ensure /dotfiles has the correct permissions
      if [ -d /dotfiles ]; then
        chown callum:dotfiles /dotfiles
        chmod 775 /dotfiles
      fi
    '';
    deps = [ "var" ];
  };
}

