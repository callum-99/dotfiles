{ self, ... }: {
  default = {
    path = "${self}";
    description = "Callums dotfiles";
  };

  devshell = {
    path = "${self}/templates/devshell";
    description = "Flake devshell template";
  };

  module = {
    path = "${self}/templates/module";
    description = "Flake module template";
  };

  overlay = {
    path = "${self}/templates/overlay";
    description = "Flake overlay template";
  };
}
