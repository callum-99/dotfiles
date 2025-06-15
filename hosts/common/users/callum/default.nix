{ config, lib, pkgs, ... }: lib.mkMerge [
  {
    # User configuration
    users.users = lib.mkMerge [
      # Common settings for both platforms
      {
        callum = {
          description = "Callum";
          shell = pkgs.zsh;
        };
      }

      # Linux-specific user settings
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        callum = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" "docker" "dotfiles" ];
          hashedPasswordFile = config.sops.secrets."USER_PASSWORD".path;
        };

        root.hashedPasswordFile = config.sops.secrets."ROOT_PASSWORD".path;
      })

      # Darwin-specific user settings
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        callum = {
          home = "/Users/callum";
        };
      })
    ];

    # Groups configuration - Linux only
    users.groups = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      dotfiles = {};
    };
  }

  # Linux-only system configuration
  (lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
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
  })
]

