{ inputs, ... }:
let
  addPatches = pkg: patches:
    pkg.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or []) ++ patches;
    });
in [
  # flake-inputs overlay
  (final: _: {
    inputs = builtins.mapAttrs (
      _: flake: let
        legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
        packages = (flake.packages or {}).${final.system} or {};
      in
        if legacyPackages != {}
        then legacyPackages
        else packages
    ) inputs;
  })

  # stable overlay
  (final: _: {
    stable = inputs.nixpkgs.legacyPackages.${final.system};
  })

  # additions overlay
  (final: prev: {
    local-pkgs = import ../pkgs { pkgs = final; };
  })
]

