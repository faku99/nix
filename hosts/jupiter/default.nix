{
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "jupiter";

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

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    powerManagement = {
      enable = false;
      finegrained = false;
    };

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  nixosConfig = {
    global.enable = true;

    users.lelisei.enable = true;

    system = {
      # sops.enable = true;
      # sudo.enable = true;
    };

    networking = {
      # headscale.enable = true;
      networkmanager.enable = true;
      # tailscale.enable = true;
    };

    # virt = {
    # docker.enable = true;
    # };
  };
}
