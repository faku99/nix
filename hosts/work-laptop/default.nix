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

    virtualisation = {
      docker.enable = true;
    };
  };

  # NFS server for RPi development
  services.nfs = {
    server = {
      enable = true;
      exports = ''
        /srv          10.0.0.0/24(rw,no_root_squash,no_subtree_check,fsid=root,crossmnt)
        /srv/proto_v0 10.0.0.0/24(rw,no_subtree_check,no_root_squash)
      '';
    };
  };

  networking.firewall = {
    enable = true;
    interfaces."enp60s0u1u3" = {
      allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
      allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
    };
  };
}
