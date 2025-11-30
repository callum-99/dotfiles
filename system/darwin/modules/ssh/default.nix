{ self, config, username, machineDir, ... }: {
  sops.secrets = {
    ssh_private_key_ed25519 = {
      sopsFile = "${self}/secrets/users/${username}/ssh/${machineDir}.yaml";
      path = "/Users/${username}/.ssh/id_ed25519";
      mode = "0600";
      owner = "${username}";
      group = "staff";
    };

    ssh_public_key_ed25519 = {
      sopsFile = "${self}/secrets/users/${username}/ssh/${machineDir}.yaml";
      path = "/Users/${username}/.ssh/id_ed25519.pub";
      mode = "0644";
      owner = "${username}";
      group = "staff";
    };

    ssh_private_key_rsa = {
      sopsFile = "${self}/secrets/users/${username}/ssh/${machineDir}.yaml";
      path = "/Users/${username}/.ssh/id_rsa";
      mode = "0600";
      owner = "${username}";
      group = "staff";
    };

    ssh_public_key_rsa = {
      sopsFile = "${self}/secrets/users/${username}/ssh/${machineDir}.yaml";
      path = "/Users/${username}/.ssh/id_rsa.pub";
      mode = "0644";
      owner = "${username}";
      group = "staff";
    };
  };
}
