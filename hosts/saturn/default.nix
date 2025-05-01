{ lib, ... }:
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
