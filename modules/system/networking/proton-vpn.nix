{
  den.aspects.proton-vpn.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.proton-vpn
      ];
    };
}
