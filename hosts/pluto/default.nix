{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "24.11";

  networking.hostName = "pluto";
  time.timeZone = "Europe/Zurich";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  # RPI kernel
  boot.kernelPackages = pkgs.linuxPackages_rpi4;

  networking.firewall.enable = false;

  nixosConfig = {
    global.enable = true;

    users.lelisei.enable = true;

    system = {
      impermanence = {
        enable = true;
        btrfs.enable = true;
        btrfs.device = "/dev/mmcblk0";
        users = [ "lelisei" ];
      };

      openssh.enable = true;
      sops.enable = true;
    };

    networking = {
      caddy = {
        enable = true;
        configFile = ./Caddyfile;
      };
      networkmanager.enable = true;
    };
  };
}
