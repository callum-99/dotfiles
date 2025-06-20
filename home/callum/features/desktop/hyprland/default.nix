{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
    ../rofi.nix
    #./hyprlock.nix
    #./hypridle.nix
    #./waybar.nix
  ];

  home.packages = with pkgs; [
    wezterm
    firefox
    ydotool
    wl-clipboard
  ];
}
