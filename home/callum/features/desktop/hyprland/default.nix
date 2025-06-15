{ pkgs, ... }: {
  imports = [
    ./hyprland.nix
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
