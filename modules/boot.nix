{
  lib,
  ...
}:
{
  myConfig.boot = {
    nixos = {
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
    };
  };
}
