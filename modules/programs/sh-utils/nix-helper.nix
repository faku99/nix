{
  # Shamelessly taken from https://github.com/uimataso/nix-config/blob/main/modules/home-manager/programs/sh-util/nix-helper.nix
  den.aspects.nix-helper.homeManager =
    { config, ... }:
    let
      flakeDir = "${config.home.homeDirectory}/nix";
    in
    {
      home.shellAliases = {
        no = "nh os switch ${flakeDir}";
        nu = "git -C ${flakeDir} pull && nh os switch ${flakeDir}";
        nt = "nh os test ${flakeDir}";
        nr = "nix repl --expr 'builtins.getFlake \"${flakeDir}\"'";
        nd = "nix develop path:$(pwd)";
      };

      programs.nh.enable = true;
    };
}
