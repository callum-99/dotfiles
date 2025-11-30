{ self, allDirs, username, inputs, config, ... }:
let
  homebrewModules = "${self}/system/darwin/modules/homebrew";
in {
  nix-homebrew = {
    enable = true;

    enableRosetta = true;

    user = username;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };

    mutableTaps = false;
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      upgrade = true;
    };

    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  imports = allDirs homebrewModules;
}
