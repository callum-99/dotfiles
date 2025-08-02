{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.module.user.variables;
in {
  options.module.user.variables = {
    enable = mkEnableOption "Enables home variables";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland";
    };
  };
}
