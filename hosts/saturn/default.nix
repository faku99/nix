{
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "saturn";

  system.stateVersion = "26.05";

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
      efiSupport = true;
    };
    systemd-boot.enable = lib.mkForce false;
    efi = {
      canTouchEfiVariables = true;
    };
  };

  boot.supportedFilesystems = [ "nfs" ];

  # Auto-log at home
  services.displayManager.autoLogin = {
    enable = true;
    user = "lelisei";
  };

  nixosConfig = {
    global.enable = true;

    users.lelisei.enable = true;

    programs = {
      steam.enable = true;
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
