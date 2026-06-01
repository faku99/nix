{
  den,
  ...
}:
{
  den.default = {
    includes = [
      den.batteries.define-user
      den.batteries.hostname
    ];

    nixos = {
      documentation.doc.enable = false;
      documentation.info.enable = false;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      system.stateVersion = "26.05";
      time.timeZone = "Europe/Zurich";
    };

    homeManager = {
      programs.home-manager.enable = true;
      home = {
        sessionPath = [ "$HOME/.local/bin" ];
        sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
        stateVersion = "26.05";
      };
    };
  };
}
