{ username, ... }: {
  programs.fuse.userAllowOther = true;

  systemd.tmpfiles.rules = [
    "d /persist/home 0755 root root -"
    "d /persist/home/${username} 0700 ${username} ${username} -"
  ];

  environment.persistence = {
    "/persist" = {
      hideMounts = true;

      directories = [
        "/etc/nixos"
        "/etc/NetworkManager/system-connections"
        "/etc/wireguard"
        "/var/lib/sbctl"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/docker"
        "/var/lib/tailscale"
        "/var/lib/containers"
        "/var/lib/qemu"
        "/var/lib/private"
        "/var/db"
        "/var/lib/NetworkManager"
        "/var/lib/chronyd"
        "/var/lib/iwd"
        "/var/lib/libvirt"
        "/var/lib/system"
      ];

      files = [
        "/etc/machine-id"
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
