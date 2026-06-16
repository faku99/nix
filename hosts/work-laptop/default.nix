{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
  ];

  networking.hostName = "work-laptop";

  system.stateVersion = "26.05";

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

  # Time settings
  time.hardwareClockInLocalTime = false;

  nixosConfig = {
    global.enable = true;

    users.lelisei.enable = true;

    system = {
      #impermanence = {
      #  enable = true;
      #  btrfs = {
      #    enable = true;
      #    device = "/dev/nvme0n1";
      #  };
      #  users = [ "lelisei" ];

      #  files = [ "/var/lib/preload/preload.state" ];
      #  directories = [ "/var/lib/fprint" ];
      #};
    };

    networking = {
      networkmanager.enable = true;
    };
  };
}
