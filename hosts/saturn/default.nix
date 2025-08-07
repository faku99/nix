{ lib, self, ... }:
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

  # Disable USB power management
  boot.kernelParams = [
    "usbcore.autosuspend=-1"
    "xhci_hcd.power_efficient=0"
  ];

  boot.extraModprobeConfig = ''
    # Solve mouse lag???
    options drm_kms_helper poll=N
  '';

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

  # Auto-log at home
  services.displayManager.autoLogin = {
    enable = true;
    user = "lelisei";
  };

  nixosConfig = {
    global.enable = true;

    users.lelisei.enable = true;

    desktop = {
      monitors = [
        {
          inherit height width;
          name = "DP-3";
          refreshRate = 144;
          primary = true;
        }
      ];
      # wallpaper.generate = {
      #   enable = true;
      #   inputSVG = "${self}/modules/nixos/theme/kcorp.svg";
      #   inherit height width;
      # };
      windowManager = {
        hyprland.enable = true;
      };
    };

    programs = {
      steam.enable = true;
      wine.enable = true;
    };

    system = {
      nix-ld.enable = true;
      sops.enable = true;
    };

    networking = {
      networkmanager.enable = true;
      openfortivpn.enable = true;
    };

    virtualisation = {
      docker.enable = true;
    };
  };
}
