{ self, machineDir, allDirs, ... }:
let
  defaultsPath = "${self}/system/machines/${machineDir}/modules/defaults";
in {
  imports = allDirs defaultsPath;
}
