{ self, config, machineDir, ... }: {
  module = {
    #sound.enable = true;
    boot = {
      enable = true;
      canTouchEfiVars = false;
      ssh = {
        port = 1722;
        hostKeys = [
          config.sops.secrets."INITRD_RSA_KEY".path
          config.sops.secrets."INITRD_ED25519_KEY".path
        ];
        authorisedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPLWRmNP3JfiduqReqiRJQDMt8uIv0O1OkVI7YDI7Tre callum@dione"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINhr5KSy+aEpl5Be/2pEVh3OKGGcUFLEsz2dJF5y+R9a nixos@titan"
        ];
      };
    };
    bluetooth.enable = true;
    locales.enable = true;
    network = {
      enable = true;
      hasWireless = true;
    };
    timedate.enable = true;
    users.enable = true;
    variables.enable = true;
    virtualisation = {
      enable = true;
      podman = { enable = true; dockerCompat = true; };
      distrobox = { enable = true; backend = "podman"; };
    };
    stylix.enable = true;
    minimal.enable = true;
    plymouth.enable = true;
    security = { enable = true; enableBootOptions = true; };

    services = {
      polkit.enable = true;
      udev.enable = true;
      zram.enable = true;
      greetd.enable = true;
      tailscale = {
        enable = true;
        authKeyFile = config.sops.secrets.TS_AUTH_KEY.path;
        loginServer = config.sops.secrets.TS_AUTH_URL.path;
        acceptDNS = true;
      };
    };

    programs = {
      dconf.enable = true;
      gnupg.enable = true;
      home-manager.enable = true;
      kdeconnect.enable = true;
      xdg-portal.enable = true;
      zsh.enable = true;
      systemPackages.enable = true;
    };
  };

  sops.secrets = {
    "INITRD_RSA_KEY" = {
      sopsFile = "${self}/secrets/machines/${machineDir}/secrets.yaml";
      neededForUsers = true;
    };

    "INITRD_ED25519_KEY" = {
      sopsFile = "${self}/secrets/machines/${machineDir}/secrets.yaml";
      neededForUsers = true;
    };

    TS_AUTH_KEY = {
      sopsFile = "${self}/secrets/machines/common.yaml";
      neededForUsers = true;
    };

    TS_AUTH_URL = {
      sopsFile = "${self}/secrets/machines/common.yaml";
      neededForUsers = true;
    };
  };
}
