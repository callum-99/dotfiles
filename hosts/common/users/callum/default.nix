{ pkgs, ... }: {
  users.users.callum = {
    description = "Callum";
    shell = pkgs.zsh;
  };
}
