{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../shared
    ../../wm/hyprland
  ];

  networking.hostName = "home-nixos";

  system.stateVersion = "24.11";

  # Make sure the kernel uses the correct driver
  boot.initrd.kernelModules = ["amdgpu"];

  boot.loader = {
    grub = {
      enable = true;
      useOSProber = true;
      device = "nodev";
      efiSupport = true;
    };
    systemd-boot.enable = lib.mkForce false;
    efi = {
      canTouchEfiVariables = true;
    };
  };
}
