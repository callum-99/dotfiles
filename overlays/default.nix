{ inputs, outputs, ... }:
let
  addPatches = pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches pr []) ++ patches;
    });
in {
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs (
      _: flake: let
        legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
	packages = (flake.packages or {}).${final.system} or {};
     in
       if legacyPackages != {}
       then legacyPackages
       else packages
    )
    
    inputs;
  };

  stable = final: _: {
    stable = inputs.nixpkgs.legacyPackages.${final.system};
  };

  additions = final: prev: {
    
  };
}
