{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.workspaces;
in {
  options.workspaces = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        id = mkOption {
          type = types.int;
          example = 1;
          description = "Workspace id";
        };

        windowRules = mkOption {
          type = types.listOf types.attrs;
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
