{ self, lib, inputs, machineDir, hostType, platform ? null, stateVersion ? null, ...}:
let
  inherit (lib) optional;

  machineConfigurationPath = "${self}/system/machines/${machineDir}";
  machineConfigurationPathExists = builtins.pathExists machineConfigurationPath;
  machineModulesPath = "${machineConfigurationPath}/modules";
  machineModulesPathExists = builtins.pathExists machineModulesPath;

  # This will throw an error if the modules path doesn't exist, showing you the exact path
  _ = if !machineModulesPathExists 
      then throw "Machine modules path does not exist: ${machineModulesPath}"
      else null;
in {
  imports = [
    "${self}/modules"
    "${self}/overlays/nixpkgs"
    "${self}/system/${hostType}/modules"
  ]
  ++ optional machineModulesPathExists machineModulesPath
  ++ optional machineConfigurationPathExists machineConfigurationPath;

  module.nix-config.enable = true;

  system = { inherit stateVersion; };

  nixpkgs = {
    hostPlatform = platform;

    overlays = [
      inputs.nur.overlays.default
    ];
  };
}
