{ self, allDirs, ... }:
let
  modules = "${self}/system/darwin/modules";
in {
  imports = allDirs modules;
}
