{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ./shell.nix
    ../features/cli
  ];

  # Common packages for all environments
  home.packages = with pkgs; [
    # CLI tools
    ripgrep
    fd
    jq
    htop
    tree
    unzip
  ];

  # Configure git
  programs.git = {
    enable = true;
    userName = "Callum Yarnold";
    userEmail = "callum@yarnold.co.uk";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # Configure direnv
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}

