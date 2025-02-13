{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../shared
    ../../wm/hyprland
  ];

  networking.hostName = "work-nixos";

  system.stateVersion = "24.11";

  # Bootloader
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

  # NVIDIA support
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  hardware.nvidia = {
    powerManagement = {
      enable = false;
      finegrained = false;
    };

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
