{
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # https://github.com/NixOS/nixos-hardware/issues/858
  boot.initrd.systemd.tpm2.enable = false;

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-uuid/278308f9-a0f6-42d4-aa22-67cd4fb55eda";
  #     fsType = "btrfs";
  #     options = [
  #       "subvol=root"
  #       "compress=zstd"
  #       "noatime"
  #     ];
  #   };

  #   "/boot" = {
  #     device = "/dev/disk/by-uuid/C8C2-1E8F";
  #     fsType = "vfat";
  #     options = [
  #       "fmask=0022"
  #       "dmask=0022"
  #     ];
  #   };

  #   "/home" = {
  #     device = "/dev/disk/by-uuid/278308f9-a0f6-42d4-aa22-67cd4fb55eda";
  #     fsType = "btrfs";
  #     options = [
  #       "subvol=home"
  #       "compress=zstd"
  #       "noatime"
  #     ];
  #   };

  #   "/persist" = {
  #     device = "/dev/disk/by-uuid/278308f9-a0f6-42d4-aa22-67cd4fb55eda";
  #     fsType = "btrfs";
  #     options = [
  #       "subvol=persist"
  #       "compress=zstd"
  #       "noatime"
  #     ];
  #   };

  #   "/nix" = {
  #     device = "/dev/disk/by-uuid/278308f9-a0f6-42d4-aa22-67cd4fb55eda";
  #     fsType = "btrfs";
  #     options = [
  #       "subvol=nix"
  #       "compress=zstd"
  #       "noatime"
  #     ];
  #   };
  # };

  # swapDevices = [ ];

  # TODO: Change?
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
