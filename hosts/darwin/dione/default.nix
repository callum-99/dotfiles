{ config, lib, pkgs, inputs, ... }: {
  imports = [
    ../../common/global
    ../../common/global/darwin.nix
    ../../common/users/callum
  ];

  # Set hostname
  networking.hostName = "dione";

  system.primaryUser = "callum";

  # macOS system settings
  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
    };
    dock = {
      autohide = true;
      orientation = "right";
      showhidden = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      ShowPathbar = true;
    };
  };

  # Enable homebrew
  #homebrew = {
  #  enable = true;
  #  onActivation.cleanup = "zap";
  #  casks = [
  #    "android-platform-tools"
  #    "aldente"
  #    "alfred"
  #    "alt-tab"
  #    "balenaetcher"
  #    "betterdisplay"
  #    "beyond-compare"
  #    "bindiff"
  #    "claude"
  #    "coconutbattery"
  #    "crossover"
  #    "daisydisk"
  #    "dbeaver-community"
  #    "ente-auth"
  #    "firefox"
  #    "font-fira-code-nerd-font"
  #    "font-fira-mono-nerd-font"
  #    "font-iosevka-nerd-font"
  #    "ghidra"
  #    "hex-fiend"
  #    "hopper-disassembler"
  #    "iterm2"
  #    "kitty"
  #    "librewolf"
  #    "lulu"
  #    "macs-fan-control"
  #    "microsoft-remote-desktop"
  #    "moonlight"
  #    "openemu"
  #    "orion"
  #    "prismlauncher"
  #    "proton-drive"
  #    "proton-mail"
  #    "proton-mail-bridge"
  #    "protonvpn"
  #    "proxyman"
  #    "qbittorrent"
  #    "raspberry-pi-imager"
  #    "rectangle"
  #    "scroll-reverser"
  #    "sitesucker-pro"
  #    "soulseek"
  #    "soundsource"
  #    "spotify"
  #    "stats"
  #    "steam"
  #    "stremio"
  #    "sublime-text"
  #    "temurin@17"
  #    "temurin@21"
  #    "upscayl"
  #    "utm"
  #    "vagrant-vmware-utility"
  #    "visual-studio-code"
  #    "vlc"
  #    "vnc-viewer"
  #    "wezterm"
  #    "xcodes"
  #    "xld"
  #  ];

  #  brews = [
  #    # Development tools
  #    "ansible"
  #    "apktool"
  #    "clang-format"
  #    "cmake"
  #    "dosbox-x"
  #    "exiftool"
  #    "eza"
  #    "fd"
  #    "gcc"
  #    "gdb"
  #    "gnupg"
  #    "jadx"
  #    "llvm"
  #    "make"
  #    "ninja"
  #    "opentofu"
  #    "pipx"
  #    "qemu"
  #    "ripgrep"
  #    "tailscale"
  #    "tree"
  #    "usbmuxd"
  #    "watch"
  #    "wget"
  #    "zoxide"
  #    "zsh"

  #    # Cross-compilation toolchains
  #    "i686-elf-binutils"
  #    "i686-elf-gcc"
  #    "i686-elf-grub"
  #    "x86_64-elf-binutils"
  #    "x86_64-elf-gcc"

  #    # Specialized tools
  #    "bochs"
  #    "dosfstools"
  #    "makefile2graph"
  #    "mtools"
  #    "nasm"
  #    "ntfy"
  #    "xcodes"
  #    "xorriso"
  #  ];
  #};

  # Darwin-specific packages
  environment.systemPackages = with pkgs; [
    coreutils
    gnupg
    wget
  ];

  # Used for backwards compatibility
  system.stateVersion = 6;
}

