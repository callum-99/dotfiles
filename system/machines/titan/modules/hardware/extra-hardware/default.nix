{ pkgs, inputs, ... }: {
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode = true;

    firmware = with pkgs; [
      linux-firmware
    ];
  };
}
