{
  config,
  lib,
  options,
  self,
  ...
}:
let
  height = 1080;
  width = 3840;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "jupiter";
  networking.timeServers = options.networking.timeServers.default ++ [ "DCTS1.tandemdiabetes.com" ];

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

  # Time settings
  time.hardwareClockInLocalTime = false;

  nixosConfig = {
    global.enable = true;

    users.lelisei.enable = true;

    desktop = {
      monitors = [
        {
          inherit height width;
          name = "DP-2";
          refreshRate = 144;
          primary = true;
        }
      ];
      wallpaper.generate = {
        enable = true;
        inputSVG = "${self}/modules/nixos/theme/kcorp.svg";
        inherit height width;
      };
      windowManager = {
        hyprland.enable = true;
      };
    };

    system = {
      impermanence = {
        enable = true;
        btrfs = {
          enable = true;
          device = "/dev/sda";
        };
        users = [ "lelisei" ];

        files = [ "/var/lib/preload/preload.state" ];
        directories = [ "/var/lib/fprint" ];
      };

      udev = {
        segger = true;
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
