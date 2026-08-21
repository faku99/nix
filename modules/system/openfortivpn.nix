{
  den.aspects.openfortivpn.nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.openfortivpn ];
    };
}
