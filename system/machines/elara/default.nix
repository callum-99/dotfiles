{ self, config, machineDir, ... }: {
  module = {
    locales.enable = true;
    network = {
      enable = true;
    };
    timedate.enable = true;
    users.enable = true;
    variables.enable = true;
    stylix = {
      enable = true;
      useCursor = true;
    };
    minimal.enable = true;

    services = {
      polkit.enable = true;
      udev.enable = true;
    };

    programs = {
      dconf.enable = true;
      gnupg.enable = true;
      home-manager.enable = true;
      zsh.enable = true;
      systemPackages.enable = true;
    };
  };
}
