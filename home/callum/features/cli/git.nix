{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Callum Yarnold";
    userEmail = "callum@yarnold.co.uk";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };

    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status";
      br = "branch";
    };
  };
}
