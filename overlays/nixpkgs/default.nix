{ inputs, ... }:
let
  baseSettings = {
    config.allowUnfree = true;
  };

  permittedInsecurePackages = [];

  unfreeSettings = baseSettings // {
    config = baseSettings.config // {
      inherit permittedInsecurePackages;
      allowUnfree = true;
    };
  };

in {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (final: _prev: {
        stable = import inputs.stable { inherit (final) system; } // baseSettings;
        stable-unfree = import inputs.stable { inherit (final) system; } // unfreeSettings;
        unstable = import inputs.stable { inherit (final) system; } // baseSettings;
        unstable-unfree = import inputs.stable { inherit (final) system; } // unfreeSettings;
      })
    ];
  };
}
