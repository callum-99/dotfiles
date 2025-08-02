{ self, allDirs, ... }:
let
  serviceModules = "${self}/system/nixos/modules/services";
in {
  imports = allDirs serviceModules;
}
