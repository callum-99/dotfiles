{ pkgs, inputs, ... }:
let
  appleFirmware = pkgs.fetchzip {
    url = "http://172.16.10.1:42069/macbook-air.zip";
    sha256 = "sha256-PNM021D6ykv/JpBwVrc7um6H/MqyGPVGjTmrFvnlbvo=";
  };
in {
  imports = [
    inputs.apple-silicon.nixosModules.apple-silicon-support
  ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    firmware = with pkgs; [
      linux-firmware
    ];

    asahi = {
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
      setupAsahiSound = true;
      peripheralFirmwareDirectory = appleFirmware;
      extractPeripheralFirmware = true;
    };
  };
}
