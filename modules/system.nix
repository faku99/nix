{
  den.default.nixos =
    { pkgs, ... }:
    {
      system.stateVersion = "26.05";

      environment.systemPackages = with pkgs; [ git ];
      fonts.packages = with pkgs; [ font-awesome ];

      programs.dconf.enable = true;
      services.gvfs.enable = true;
      services.printing = {
        enable = true;
        drivers = [ pkgs.gutenprint ];
      };
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      security.sudo.wheelNeedsPassword = false;
    };
}
