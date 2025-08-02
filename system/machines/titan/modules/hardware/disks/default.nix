{ lib, ... }: {
  boot.initrd = {
    postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/vg/root /btrfs_tmp
      
      # Ensure old_roots directory exists
      mkdir -p /btrfs_tmp/old_roots
      
      # Check if @ subvolume exists (not "root")
      if [[ -e /btrfs_tmp/@ ]]; then
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/@ "/btrfs_tmp/old_roots/$timestamp"
      fi
      
      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }
      
      # Clean up old roots (now this won't fail since directory exists)
      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30 -type d -not -name old_roots); do
          delete_subvolume_recursively "$i"
      done
      
      # Create new @ subvolume
      btrfs subvolume create /btrfs_tmp/@
      umount /btrfs_tmp
    '';
  };

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "5G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            luks = {
              size = "100%";
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
        };
      };
    };
    lvm_vg = {
      vg = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = "80G";
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
