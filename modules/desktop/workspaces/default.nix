{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.types) attrsOf submodule int listOf attrs;

  cfg = config.machine.workspaces;
in {
  options.machine.workspaces = mkOption {
    type = attrsOf (submodule {
      options = {
        id = mkOption {
          type = int;
          example = 1;
          description = "Workspace id";
        };

        windowRules = mkOption {
          type = listOf attrs;
          default = [];
          description = "Regex for matching window rules";
          example = [
            { class = "^firefox$"; }
            { class = "^Google Chrome"; }
            { class = "code"; title = ".*\\.nix$"; }
          ];
        };
      };
    });

    default = {};
    description = "Workspace definitions";
  };
}
