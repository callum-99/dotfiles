{ self, config, pkgs, lib, inputs, hostname, username, platform, hmStateVersion, isWorkstation ? false, wm ? "", theme, hyprlandEnable ? false, wmEnable ? false, allDirs, stripTrailingZeros, keyboardLayout, keyboardVariant, ...}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
  inherit (lib) optional;

  stateVersion = hmStateVersion;
  isRoot = username == "root";
  homeDirectory = if isDarwin then "/Users/${username}" else if isRoot then "/root" else "/home/${username}";
  userConfigurationPath = "${self}/home/users/${username}";
  userConfigurationPathExists = builtins.pathExists userConfigurationPath;
  userModulesPath = "${self}/home/users/${username}/modules";
  userModulesPathExists = builtins.pathExists userModulesPath;
in {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup" + pkgs.lib.readFile "${pkgs.runCommand "timestamp" {} "echo -n `date '+%Y%m%d%H%M%S'` > $out"}";

    extraSpecialArgs = {
      inherit
        inputs
        self
        allDirs
        stripTrailingZeros
        hostname
        username
        platform
        stateVersion
        isLinux
        isDarwin
        isWorkstation
        wm
        theme
        hyprlandEnable
        wmEnable
        keyboardLayout
        keyboardVariant
      ;

      inherit (config) machine;
    };

    users.${username} = {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
        inputs.nur.modules.homeManager.default
        inputs.nixvim.homeModules.nixvim
        inputs.betterfox.homeModules.betterfox

        "${self}/modules"
        "${self}/home/modules"
      ]
      ++ optional isLinux inputs.impermanence.nixosModules.home-manager.impermanence
      ++ optional userConfigurationPathExists userConfigurationPath
      ++ optional userModulesPathExists userModulesPath;

      home = {
        inherit username;
        inherit stateVersion;
        inherit homeDirectory;
      };
    };
  };
}
