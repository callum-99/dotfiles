{ config, lib, pkgs, ... }: {
  environment.persistence."/persist" = {
    directories = [
      "/var/lib/bluetooth"
      "/var/lib/flatpak"
      "/var/lib/sbctl"
    ];

    users.callum = {
      directories = [
        # Desktop-specific
        "Documents"
        "Downloads"

        # Development
        "Developer"
        "Git"

        # Application state
        ".mozilla"
        ".cache/mozilla"
        ".local/share/Steam"
        ".local/share/direnv"
        ".local/share/nvim"
        ".local/share/zsh"
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };
}
