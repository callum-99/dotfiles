{
  description = "Modernized NixOS and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, darwin, nixos-wsl, flake-parts, sops-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Make pkgs available to all modules
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Make unstable available to all modules
        _module.args.pkgsUnstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

        # Custom packages
        packages = import ./pkgs { inherit pkgs; };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            nil
            nixpkgs-fmt
            sops
            gnupg
	    age
          ];
        };

        # Formatter for nix files
        formatter = pkgs.nixpkgs-fmt;
      };

      flake = {
        # Import custom library functions
        lib = import ./lib { inherit inputs; };

        # Import overlays
        overlays = import ./overlays { inherit inputs; };

        # NixOS configurations
        nixosConfigurations = {
          titan = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/nixos/titan
              home-manager.nixosModules.home-manager
              sops-nix.nixosModules.sops
              ./modules/sops
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; };
                home-manager.users.callum = {
		  imports = [
		    ./home/callum/profiles/titan.nix
		    sops-nix.homeManagerModules.sops
		    ./home/modules/sops.nix
		  ];
		};
              }
            ];
          };
        };

        # Darwin configurations
        darwinConfigurations = {
          dione = darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/darwin/dione
              home-manager.darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; };
                home-manager.users.callum = {
		  imports = [
		    ./home/callum/profiles/titan.nix
		    sops-nix.homeManagerModules.sops
		    ./home/modules/sops.nix
		  ];
		};
              }
            ];
          };
        };

        # Standalone home-manager configurations
        homeConfigurations = {
          # Linux (non-NixOS) configuration
          "callum@titan" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home/callum/profiles/titan.nix
              sops-nix.homeManagerModules.sops
	      ./home/modules/sops.nix
            ];
          };

          # macOS configuration (standalone)
          "callum@dione" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            extraSpecialArgs = { inherit inputs; };
            modules = [
              ./home/callum/profiles/dione.nix
              sops-nix.homeManagerModules.sops
	      ./home/modules/sops.nix
            ];
          };
        };
      };
    };
}

