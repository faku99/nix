{ lib, ... }:
let
  height = 1440;
  width = 2560;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "saturn";

  system.stateVersion = "24.11";

  # Make sure the kernel uses the correct driver
  boot.initrd.kernelModules = [ "amdgpu" ];

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

  nixosConfig = {
    global.enable = true;

    users.lelisei.enable = true;

    system = {
      # sops.enable = true;
      # sudo.enable = true;
    };

    monitors = [
      {
        inherit height width;
        name = "DP-3";
        refreshRate = 144;
        primary = true;
      }
    ];

    networking = {
      # headscale.enable = true;
      networkmanager.enable = true;
      # tailscale.enable = true;
    };

    windowManager = {
      hyprland.enable = true;
    };

    # virt = {
    # docker.enable = true;
    # };
  };
}
