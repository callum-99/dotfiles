{ lib, ... }: 
let
  modules = builtins.filter (name:
    name != "default.nix"
  ) (builtins.attrNames (builtins.readDir ./.));

  moduleImports = map (file: ./. + "/${file}") modules;
in {
  imports = moduleImports;
}
