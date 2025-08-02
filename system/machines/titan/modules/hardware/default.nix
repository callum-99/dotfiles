{ self, machineDir, allDirs, ... }:
let
  hardwareModulesPath = "${self}/system/machines/${machineDir}/modules/hardware";
in {
  imports = allDirs hardwareModulesPath;
}
