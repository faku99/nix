{
  den.aspects.saturn.nixos = {
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/ed972b91-0dc3-48e7-85fa-17423c4728e9";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/B588-EA6F";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-uuid/2d2ff537-2c2c-4e30-ac23-b9fa54e3e7da";
      fsType = "ext4";
    };
  };
}
