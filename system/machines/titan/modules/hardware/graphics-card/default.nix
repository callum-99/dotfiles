{ config, ... }: {
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      nvidiaSettings = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
