{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ../rofi.nix
    ../waybar.nix
    #./hyprlock.nix
    #./hypridle.nix
  ];

  home.packages = with pkgs; [
    wezterm
    firefox
    ydotool
    wl-clipboard
  ];
}
