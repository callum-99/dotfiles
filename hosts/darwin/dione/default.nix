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
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    casks = [
      "aldente"
      "alfred"
      "alt-tab"
      "balenaetcher"
      "betterdisplay"
      "beyond-compare"
      "bindiff"
      "coconutbattery"
      "crossover"
      "daisydisk"
      "dbeaver-community"
      "ente-auth"
      "firefox"
      "font-fira-code-nerd-font"
      "font-fira-mono-nerd-font"
      "font-iosevka-nerd-font"
      "ghidra"
      "hex-fiend"
      "hopper-disassembler"
      "iterm2"
      "kitty"
      "librewolf"
      "lulu"
      "macs-fan-control"
      "microsoft-remote-desktop"
      "moonlight"
      "openemu"
      "orion"
      "prismlauncher"
      "proton-drive"
      "proton-mail"
      "proton-mail-bridge"
      "protonvpn"
      "proxyman"
      "qbittorrent"
      "raspberry-pi-imager"
      "rectangle"
      "scroll-reverser"
      "sitesucker-pro"
      "soulseek"
      "soundsource"
      "spotify"
      "stats"
      "steam"
      "stremio"
      "sublime-text"
      "temurin@17"
      "temurin@21"
      "upscayl"
      "utm"
      "vagrant-vmware-utility"
      "visual-studio-code"
      "vlc"
      "vnc-viewer"
      "wezterm"
      "xcodes"
      "xld"
    ];

    brews = [
      "ansible"
      "aom"
      "apprise"
      "assimp"
      "autoconf"
      "autoconf-archive"
      "automake"
      "bat"
      "binutils"
      "blake3"
      "bochs"
      "brotli"
      "cairo"
      "capstone"
      "ccache"
      "clang-format"
      "cmake"
      "dbus"
      "dnspyre"
      "doggo"
      "dosbox-x"
      "dosfstools"
      "double-conversion"
      "dtc"
      "exiftool"
      "eza"
      "fd"
      "flac"
      "fluid-synth"
      "fmt"
      "fontconfig"
      "freetype"
      "fribidi"
      "fzf"
      "gcc"
      "gd"
      "gdb"
      "gdk-pixbuf"
      "gettext"
      "giflib"
      "glib"
      "gmp"
      "gnupg"
      "gnutls"
      "graphite2"
      "graphviz"
      "gts"
      "harfbuzz"
      "highway"
      "hiredis"
      "hunspell"
      "i686-elf-binutils"
      "i686-elf-gcc"
      "i686-elf-grub"
      "icu4c@77"
      "imath"
      "isl"
      "jasper"
      "jpeg-turbo"
      "jpeg-xl"
      "just"
      "lame"
      "libassuan"
      "libavif"
      "libb2"
      "libdeflate"
      "libevent"
      "libgcrypt"
      "libgit2"
      "libgpg-error"
      "libidn2"
      "libksba"
      "libmng"
      "libmpc"
      "libnghttp2"
      "libogg"
      "libpng"
      "librsvg"
      "libslirp"
      "libsndfile"
      "libssh2"
      "libtasn1"
      "libtiff"
      "libtool"
      "libunistring"
      "libusb"
      "libuv"
      "libvmaf"
      "libvorbis"
      "libx11"
      "libxau"
      "libxcb"
      "libxdmcp"
      "libxext"
      "libxrender"
      "little-cms2"
      "lld"
      "llvm"
      "lpeg"
      "luajit"
      "luv"
      "lz4"
      "lzo"
      "m4"
      "makefile2graph"
      "md4c"
      "mpfr"
      "mpg123"
      "mtools"
      "nasm"
      "ncurses"
      "neovim"
      "netpbm"
      "nettle"
      "ninja"
      "npth"
      "ntfy"
      "oniguruma"
      "openexr"
      "opentofu"
      "opus"
      "p11-kit"
      "pango"
      "pcre2"
      "pinentry"
      "pipx"
      "pixman"
      "pkgconf"
      "podman"
      "portaudio"
      "python-setuptools"
      "qemu"
      "qt"
      "ripgrep"
      "sdl12-compat"
      "sdl2"
      "snappy"
      "tailscale"
      "tmux"
      "tree"
      "tree-sitter"
      "unbound"
      "unibilium"
      "utf8proc"
      "vde"
      "wakeonlan"
      "watch"
      "webp"
      "wget"
      "x86_64-elf-binutils"
      "x86_64-elf-gcc"
      "xcodes"
      "xorgproto"
      "xorriso"
      "xxhash"
      "z3"
      "zoxide"
      "zsh"
      "zstd"
    ];
  };

  # Darwin-specific packages
  environment.systemPackages = with pkgs; [
    coreutils
    gnupg
    wget
  ];

  # Used for backwards compatibility
  system.stateVersion = 6;
}

