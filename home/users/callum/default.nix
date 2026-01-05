{ config, isWorkstation, isLinux, isDarwin, self, username, hostname, hyprlandEnable ? false, wmEnable ? false, ... }: {
  module = {
    dconf.enable = isLinux;
    emacs.enable = wmEnable;
    firefox.enable = true;
    flameshot.enable = wmEnable;
    git.enable = true;
    hypridle.enable = wmEnable && hyprlandEnable;
    hyprland.enable = wmEnable && hyprlandEnable;
    hyprlock.enable = wmEnable && hyprlandEnable;
    waybar.enable = wmEnable && hyprlandEnable;
    neovim.enable = isWorkstation;
    rofi.enable = wmEnable;
    shell.enable = true;
    wezterm.enable = true;
    tmux.enable = true;

    user = {
      ssh.enable = true;
      xdg.enable = isLinux && isWorkstation;
      packages.enable = true;
      variables.enable = true;
    };
  };

  sops = {
    #age.keyFile = if isLinux then "${config.home.homeDirectory}/.config/sops/age/keys.txt" else "${config.home.homeDirectory}/Library/Applications Support/sops/age/keys.txt";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
    };
  };
}
