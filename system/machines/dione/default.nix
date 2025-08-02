{ inputs, pkgs, username, ... }: {
  module = {
    stylix = {
      enable = true;
      useCursor = false;
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    home-manager
    nerd-fonts.fira-code
    wezterm
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    description = username;
  };

  programs.zsh.enable = true;

  system.configurationRevision = inputs.rev or inputs.dirtyRev or null;
}
