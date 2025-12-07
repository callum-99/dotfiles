{
  description = "Callums dotfiles";

  inputs = {
    stable.url = "github:nixos/nixpkgs/nixos-25.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    stable-darwin.url = "github:nixos/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs.follows = "stable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";

    darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };

    apple-silicon.url = "github:tpwrules/nixos-apple-silicon";

    home-manager.url = "github:nix-community/home-manager/release-25.11";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    sops-nix.url = "github:Mic92/sops-nix";

    stylix.url = "github:nix-community/stylix/release-25.11";

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";

    disko.url = "github:nix-community/disko";

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote.url = "github:nix-community/lanzaboote";

    hyprland.url = "github:hyprwm/hyprland";

    nur.url = "github:nix-community/NUR";

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
