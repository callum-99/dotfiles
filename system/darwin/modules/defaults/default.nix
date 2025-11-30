{ self, allDirs, username, ... }:
let
  defaultsModules = "${self}/system/darwin/modules/defaults";
in {
  system.primaryUser = username;
  imports = allDirs defaultsModules;
}
