{
  den.aspects.okular.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kdePackages.okular ];
    };
}
