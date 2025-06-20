{
  description = "Callums dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, darwin, nixos-wsl, flake-parts, sops-nix, stylix, nixvim, disko, impermanence, lanzaboote, nur, ... }:
    let
      overlays = [
        nur.overlays.default
      ] ++ (import ./overlays { inherit inputs; });

      nixPkgsConfig = {
        allowUnfree = true;
        inherit overlays;
      };
    in flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Make pkgs available to all modules
        _module.args.pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          inherit overlays;
        };

        # Make unstable available to all modules
        _module.args.pkgsUnstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          inherit overlays;
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
            just
          ];
        };

        # Formatter for nix files
        formatter = pkgs.nixpkgs-fmt;
      };

      flake = {
        # Import custom library functions
        lib = import ./lib { inherit inputs; };

        # Import overlays
        inherit overlays;

        # NixOS configurations
        nixosConfigurations = {
          titan = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./hosts/nixos/titan
              home-manager.nixosModules.home-manager
              sops-nix.nixosModules.sops
              stylix.nixosModules.stylix
              disko.nixosModules.disko
              impermanence.nixosModules.impermanence
              lanzaboote.nixosModules.lanzaboote
              nur.modules.nixos.default
             ./modules/sops
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; helpers = self.lib; };
                home-manager.users.callum = {
                  imports = [
                    ./home/callum/profiles/titan.nix
                    sops-nix.homeManagerModules.sops
                    nixvim.homeManagerModules.nixvim
                    ./home/modules/sops.nix
                  ];
                };
              }
            ];
          };

          elara = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./hosts/wsl/elara
              home-manager.nixosModules.home-manager
              sops-nix.nixosModules.sops
              nixos-wsl.nixosModules.default
              nur.modules.nixos.default
              ./modules/sops
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.extraSpecialArgs = { inherit inputs; helpers = self.lib; };
                home-manager.users.callum = {
                  imports = [
                    ./home/callum/profiles/elara.nix
                    sops-nix.homeManagerModules.sops
                    nixvim.homeManagerModules.nixvim
                    ./home/modules/sops.nix
                  ];
                };
              }
            ];
          };

          wsl = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./hosts/wsl/wsl
              home-manager.nixosModules.home-manager
              sops-nix.nixosModules.sops
              stylix.nixosModules.stylix
              nixos-wsl.nixosModules.default
              nur.modules.nixos.default
              ./modules/sops
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; helpers = self.lib; };
                home-manager.users.callum = {
                  imports = [
                    ./home/callum/profiles/wsl.nix
                    sops-nix.homeManagerModules.sops
                    nixvim.homeManagerModules.nixvim
                    ./home/modules/sops.nix
                  ];
                };
              }
            ];
          };

          phobos = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            specialArgs = { inherit inputs; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./hosts/nixos/phobos
              home-manager.nixosModules.home-manager
              sops-nix.nixosModules.sops
              stylix.nixosModules.stylix
              nur.modules.nixos.default
              ./modules/sops
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.extraSpecialArgs = { inherit inputs; helpers = self.lib; };
                home-manager.users.callum = {
                  imports = [
                    ./home/callum/profiles/phobos.nix
                    sops-nix.homeManagerModules.sops
                    nixvim.homeManagerModules.nixvim
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
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./hosts/darwin/dione
              sops-nix.darwinModules.sops
              stylix.darwinModules.stylix
              home-manager.darwinModules.home-manager
              nur.modules.darwin.default
              ./modules/sops
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit inputs; helpers = self.lib; };
                home-manager.users.callum = {
                  imports = [
                    ./home/callum/profiles/dione.nix
                    sops-nix.homeManagerModules.sops
                    nixvim.homeManagerModules.nixvim
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
            extraSpecialArgs = { inherit inputs; helpers = self.lib; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./home/callum/profiles/titan.nix
              sops-nix.homeManagerModules.sops
              stylix.homeModules.stylix
              nixvim.homeManagerModules.nixvim
              nur.modules.homeManager.default
              ./home/modules/sops.nix
            ];
          };

          "callum@elara" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; helpers = self.lib; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./home/callum/profiles/elara.nix
              stylix.homeModules.stylix
              nixvim.homeManagerModules.nixvim
              sops-nix.homeManagerModules.sops
              nur.modules.homeManager.default
              ./home/modules/sops.nix
            ];
          };

          "callum@wsl" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs; helpers = self.lib; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./home/callum/profiles/wsl.nix
              sops-nix.homeManagerModules.sops
              stylix.homeModules.stylix
              nixvim.homeManagerModules.nixvim
              nur.modules.homeManager.default
              ./home/modules/sops.nix
            ];
          };

          # macOS configuration (standalone)
          "callum@dione" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.aarch64-darwin;
            extraSpecialArgs = { inherit inputs; helpers = self.lib; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./home/callum/profiles/dione.nix
              sops-nix.homeManagerModules.sops
              stylix.homeModules.stylix
              nixvim.homeManagerModules.nixvim
              nur.modules.homeManager.default
              ./home/modules/sops.nix
            ];
          };

          "callum@phobos" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.aarch64-linux;
            extraSpecialArgs = { inherit inputs; helpers = self.lib; };
            modules = [
              { nixpkgs.overlays = overlays; nixpkgs.config = nixPkgsConfig; }
              ./home/callum/profiles/phobos.nix
              stylix.homeModules.stylix
              nixvim.homeManagerModules.nixvim
              sops-nix.homeManagerModules.sops
              nur.modules.homeManager.default
              ./home/modules/sops.nix
            ];
          };
        };
        templates = {
          default = {
            path = ./.;
            description = "Callums dotfiles";
            welcomeText = ''
              # NixOS Configuration Template

              You have created a new NixOS/Darwin configuration!

              ## Next steps:

              1. Initialize machine:
                just init-machine <hostname>

              2. Add the displayed age key to secrets/.sops.yaml

              3. Deploy system:
                just deploy
            '';
          };
        };
      };
    };
}

