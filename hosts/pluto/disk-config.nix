{ lib, self, ... }:
let
  persist_dir = "/persistent";
in
{
  imports = [ self.inputs.disko.nixosModules.default ];

  fileSystems = {
    "/" = {
      fsType = lib.mkForce "tmpfs";
      device = lib.mkForce "none";
    };
    ${persist_dir}.neededForBoot = true;
  };

  disko = {
    enableConfig = true;
    devices = {
      nodev."/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=1G"
          "defaults"
          "mode=755"
        ];
      };
      disk = {
        system = {
          type = "disk";
          device = "/dev/mmcblk0";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                start = "1M";
                end = "128M";
                label = "BOOTFS";
                type = "EF00";
                device = "/dev/disk/by-label/BOOTFS";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "umask=0077"
                    "nofail"
                    "noauto"
                  ];
                };
              };

              root = {
                size = "100%";
                label = "rootfs";
                device = "/dev/disk/by-label/rootfs";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = persist_dir;
                  mountOptions = [ "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
