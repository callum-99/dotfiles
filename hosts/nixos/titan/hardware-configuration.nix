{ config, lib, pkgs, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices."cryptlvm" = {
    device = "/dev/disk/by-uuid/a617ebb3-baf9-4c76-8cb5-ae63934b98ad";
    preLVM = true;
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/cdd9d163-bda9-4eb8-8139-90102fbd2c9a";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/cdd9d163-bda9-4eb8-8139-90102fbd2c9a";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/cdd9d163-bda9-4eb8-8139-90102fbd2c9a";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/cdd9d163-bda9-4eb8-8139-90102fbd2c9a";
    fsType = "btrfs";
    options = [ "subvol=@log" "compress=zstd" "noatime" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/cdd9d163-bda9-4eb8-8139-90102fbd2c9a";
    fsType = "btrfs";
    options = [ "subvol=@persist" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6EA3-88C8";
    fsType = "vfat";
    options = [ "umask=0077" "fmask=0077" "dmask=0077" "noatime" ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/27da20bd-effc-4ec7-a952-f0ffa2262f6e";
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
