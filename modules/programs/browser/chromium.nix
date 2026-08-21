{
  den.aspects.chromium.homeManager =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
      };
    };
}
