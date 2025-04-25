{
  pkgs,
  ...
}:

{
  imports = [
    ./disk-config.nix
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
      # sops.enable = true;
      # sudo.enable = true;

      impermanence = {
        enable = true;
        # btrfs.enable = true;
        # btrfs.device = "/dev/mmcblk0";
        users = [ "lelisei" ];
      };
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
