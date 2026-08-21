{
  den.aspects.networkmanager.nixos =
    { lib, pkgs, ... }:
    {
      networking.networkmanager = {
        enable = true;
        plugins = [ pkgs.networkmanager-openconnect ];
      };

      # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
      systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
      systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;
    };
}
