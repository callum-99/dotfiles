{ self, machineDir, allDirs, ... }:
let
  modules = "${self}/system/machines/${machineDir}/modules";
in {
  imports = allDirs modules;
}
