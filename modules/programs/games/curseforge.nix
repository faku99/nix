{
  den.aspects.curseforge.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.curseforge ];
    };
}
