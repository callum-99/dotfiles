{ pkgs, ... }: {
  imports = [
    ./podman.nix
  ];

  environment.systemPackages = with pkgs; [
    distrobox
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
