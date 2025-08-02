{
  description = "DevShell for project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, nixpkgs, ... }: flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShell.default = pkgs.mkShell {
          buildInputs = with pkgs; [

          ];
        };

        # Formatter for nix files
        formatter = pkgs.nixpkgs-fmt;
      };
    };
}
