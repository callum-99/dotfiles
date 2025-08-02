{ config, lib, pkgs, ... }:
let
  pluginFiles = builtins.filter 
    (name: name != "default.nix" && lib.hasSuffix ".nix" name)
    (builtins.attrNames (builtins.readDir ./.));

  kickstartPluginFiles = builtins.map 
    (name: ./kickstart/plugins + "/${name}")
    (builtins.filter 
      (name: lib.hasSuffix ".nix" name)
      (builtins.attrNames (builtins.readDir ./kickstart/plugins)));

  pluginPaths = builtins.map (name: ./. + "/${name}") pluginFiles;

  allPluginPaths = pluginPaths ++ kickstartPluginFiles;
in {
  imports = allPluginPaths;
}
