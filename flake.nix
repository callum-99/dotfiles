{
  description = "Callums dotfiles";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-25.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "stable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:nix-community/stylix/release-25.05";

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    betterfox.url = "github:HeitorAugustoLN/betterfox-nix";
  };

  outputs = { self, flake-parts, ... } @ inputs:
  let
    hosts = import ./hosts.nix;

    libx = import ./lib { inherit self inputs; };
  in flake-parts.lib.mkFlake { inherit inputs; } {
    systems = libx.forAllSystems;

    imports = [ ./parts ];

    flake = {
      nixosConfigurations  = libx.genNixOS hosts.nixos;
      darwinConfigurations = libx.genDarwin hosts.darwin;
      templates            = import "${self}/templates" { inherit self; };
    };
  };
}
