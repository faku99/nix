{
  den.aspects.udev.nixos =
    { pkgs, ... }:
    {
      services.udev.packages = with pkgs; [
        saleae-logic-2
        stlink
      ];

      users.groups.dialout = { };
      users.users.lelisei.extraGroups = [ "dialout" ];
    };
}
