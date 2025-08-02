{ config, lib, self, hostname, ... }: {
  config = {
    sops = {
      age = {
        generateKey = false;
        sshKeyPaths = [];
        keyFile = lib.mkDefault "/var/lib/sops-nix/key.txt";
      };

      defaultSopsFile = "${self}/secrets/secrets.yaml";

      gnupg.sshKeyPaths = [];
    };
  };
}
