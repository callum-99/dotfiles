{ config, lib, self, pkgs, username, machineDir, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.users;
in {
  options.module.users = {
    enable = mkEnableOption "Enables users";
  };

  config = mkIf cfg.enable {
    users = {
      mutableUsers = false;

      groups = {
        ${username} = {
          gid = 1000;
        };
      };

      users = {
        ${username} = {
          uid = 1000;
          home = "/home/${username}";
          shell = pkgs.zsh;
          group = username;
          createHome = true;
          description = "${username}";
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."${username}_hash".path;

          extraGroups = [
            "audio"
            "networkmanager"
            "wheel"
            "docker"
            "libvirtd"
            "podman"
            "video"
          ];
        };

        root = {
          shell = pkgs.zsh;
          hashedPasswordFile = config.sops.secrets.root_hash.path;
        };
      };
    };
    sops.secrets = {
      "${username}_hash" = {
        sopsFile = "${self}/secrets/machines/common.yaml";
        neededForUsers = true;
      };

      root_hash = {
        sopsFile = "${self}/secrets/machines/common.yaml";
        neededForUsers = true;
      };

      ssh_private_key_ed25519 = {
        sopsFile = "${self}/secrets/users/${username}/ssh/${machineDir}.yaml";
        path = "/home/${username}/.ssh/id_ed25519";
        mode = "0600";
        uid = config.users.users.${username}.uid;
        gid = config.users.groups.${username}.gid;
      };

      ssh_public_key_ed25519 = {
        sopsFile = "${self}/secrets/users/${username}/ssh/${machineDir}.yaml";
        path = "/home/${username}/.ssh/id_ed25519.pub";
        mode = "0644";
        uid = config.users.users.${username}.uid;
        gid = config.users.groups.${username}.gid;
      };

      ssh_private_key_rsa = {
        sopsFile = "${self}/secrets/users/${username}/ssh/${machineDir}.yaml";
        path = "/home/${username}/.ssh/id_rsa";
        mode = "0600";
        uid = config.users.users.${username}.uid;
        gid = config.users.groups.${username}.gid;
      };

      ssh_public_key_rsa = {
        sopsFile = "${self}/secrets/users/${username}/ssh/${machineDir}.yaml";
        path = "/home/${username}/.ssh/id_rsa.pub";
        mode = "0644";
        uid = config.users.users.${username}.uid;
        gid = config.users.groups.${username}.gid;
      };
    };
  };
}
