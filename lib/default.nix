{ self, inputs, ... }:
let
  defaultStateVersion = "25.05";
  defaultDarwinStateVersion = 6;

  stripTrailingZeros = float:
  let
    s = toString float;
    # This regex captures the integer part and the decimal part up to the last nonzero digit
    match = builtins.match "([0-9]+\\.[0-9]*[1-9])0*$" s;
    result = if match != null then builtins.elemAt match 0 else
             # If it's all zeros after the dot, capture just the integer part
             (let intMatch = builtins.match "([0-9]+)\\.0*$" s;
              in if intMatch != null then builtins.elemAt intMatch 0 else s);
  in result;

  allDirs = dirName:
    builtins.filter (
      module: ((builtins.pathExists module) && ((builtins.readFileType module) == "directory"))
    ) (map (module: "${dirName}/${module}") (builtins.attrNames (builtins.readDir dirName)));

  constructors = [
    "${self}/home"
    "${self}/system"
  ];

  mkHost = machineDir: {
    username ? "user",
    pkgsInput ? "stable",
    stateVersion ? defaultStateVersion,
    hmStateVersion ? stateVersion,
    platform ? "x86_64-linux",
    hostname ? machineDir,
    isWorkstation ? false,
    wm ? null,
    theme ? null,
    hostType ? "nixos",
    keyboardLayout ? "gb",
    keyboardVariant ? "",
  }: let
    chosenPkgs = inputs.${pkgsInput};
    nixosSystem = chosenPkgs.lib.nixosSystem;
    hyprlandEnable = (wm == "hyprland");
    wmEnable = hyprlandEnable;
  in nixosSystem {
    specialArgs = {
      inherit
        inputs
        pkgsInput
        self
        allDirs
        stripTrailingZeros
        hostname
        username
        stateVersion
        hmStateVersion
        platform
        machineDir
        isWorkstation
        wm
        theme
        hyprlandEnable
        wmEnable
        hostType
        keyboardLayout
        keyboardVariant
      ;
    };

    modules = with inputs; [
      home-manager.nixosModules.home-manager
      stylix.nixosModules.stylix
      impermanence.nixosModules.impermanence
      disko.nixosModules.disko
      lanzaboote.nixosModules.lanzaboote
      sops-nix.nixosModules.sops
      nur.modules.nixos.default
      nixvim.nixosModules.nixvim
      nixos-wsl.nixosModules.default
    ] ++ constructors;
  };

  mkHostDarwin = machineDir: {
    username ? "user",
    pkgsInput ? "stable-darwin",
    stateVersion ? defaultDarwinStateVersion,
    hmStateVersion ? stateVersion,
    hostname ? machineDir,
    platform ? "aarch64-darwin",
    isWorkstation ? false,
    wm ? null,
    theme ? "gruvbox-dark",
    hostType ? "darwin",
  }: let
    chosenPkgs = inputs.${pkgsInput};
    darwinSystem = inputs.darwin.lib.darwinSystem;
    hyprlandEnable = false;
    wmEnable = false;
  in darwinSystem {
    specialArgs = {
      inherit
        inputs
        pkgsInput
        self
        allDirs
        stripTrailingZeros
        hostname
        username
        stateVersion
        hmStateVersion
        platform
        machineDir
        isWorkstation
        wm
        theme
        hyprlandEnable
        wmEnable
        hostType
      ;
    };

    modules = with inputs; [
      home-manager.darwinModules.home-manager
      stylix.darwinModules.stylix
      sops-nix.darwinModules.sops
      nur.modules.darwin.default
      nixvim.nixDarwinModules.nixvim
      nix-homebrew.darwinModules.nix-homebrew
    ] ++ constructors;
  };
in {
  forAllSystems = inputs.stable.lib.systems.flakeExposed;

  genNixOS = builtins.mapAttrs mkHost;
  genDarwin = builtins.mapAttrs mkHostDarwin;
}
