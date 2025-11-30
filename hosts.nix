{
  nixos = {
    titan = {
      username = "callum";
      platform = "x86_64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      wm = "hyprland";
      theme = "gruvbox-dark";
    };

    elara = {
      username = "callum";
      platform = "x86_64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      theme = "gruvbox-dark";
    };

    wsl = {
      username = "callum";
      platform = "x86_64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      theme = "gruvbox-light";
    };

    phobos = {
      username = "callum";
      platform = "aarch64-linux";
      stateVersion = "25.05";
      isWorkstation = true;
      wm = "hyprland";
      theme = "gruvbox-dark";
      keyboardLayout = "gb";
      keyboardVariant = "mac";
    };
  };

  darwin = {
    dione = {
      username = "callum";
      platform = "aarch64-darwin";
      pkgsInput = "unstable";
      stateVersion = 6;
      hmStateVersion = "25.05";
      isWorkstation = true;
      theme = "gruvbox-dark";
    };
  };
}
