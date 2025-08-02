{ lib, ... }: {
  boot.initrd = {
    luks.devices."crypt" = {
      device = "/dev/nvme0n1p5";
      preLVM = true;
      allowDiscards = true;
    };

    postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi
      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }
      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done
      btrfs subvolume create /btrfs_tmp/@
      umount /btrfs_tmp
    '';
  };

  disko.devices = {
    disk = {
      boot = {
        type = "disk";
        device = "/dev/nvme0n1p4";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "defaults" "umask=0077" ];
          extraArgs = [ "--no-format" ];
        };
      };
      crypt = {
        type = "disk";
        device = "/dev/nvme0n1p5";
        content = {
          type = "luks";
          name = "crypt";
          settings = {
            allowDiscards = true;
          };

          content = {
            type = "lvm_pv";
            vg = "vg";
          };
        };
      };
    };

    lvm_vg = {
      vg = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = "8G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };

          root = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@log" = {
                  mountpoint = "/var/log";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };

                "@dotfiles" = {
                  mountpoint = "/dotfiles";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };

  fileSystems = {
    "/persist".neededForBoot = true;

    "/var/lib/sops-nix" = {
      device = "/persist/var/lib/sops-nix";
      fsType = "none";
      options = [ "bind" ];
      neededForBoot = true;
    };
  };
}
