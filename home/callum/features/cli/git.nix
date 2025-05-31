{ config, pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Callum Yarnold";
    userEmail = "callum@yarnold.co.uk";
    signing = {
      format = "ssh";
      key = "~/.ssh/id_rsa.pub";
      signByDefault = true;
    };

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
