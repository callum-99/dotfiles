{ inputs, lib, config, pkgs, username, ... }:
let
  inherit (lib) mkEnableOption mkOption mkIf;
  inherit (lib.types) bool;

  cfg = config.module.nix-config;
in {
  options.module.nix-config = {
    enable = mkEnableOption "Enables nix-config";

    useNixPackageManagerConfig = mkOption {
      type = bool;
      description = "Wether to use custom nix package manager settings";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    nix = {
      package = pkgs.nix;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        allowed-users = [ "@wheel" ];

        trusted-users = [
          "root"
          username
        ];

        substituters = [
          "https://hyprland.cachix.org"
          "https://devenv.cachix.org"
        ];

        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        ];
      };
    };
  };
}
