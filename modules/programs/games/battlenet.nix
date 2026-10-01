{ lib, ... }:
{
  den.schema.host.imports = [
    {
      options.battlenet.dir = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Battle.net install dir relative to $HOME, inside a drive_c Proton prefix.";
      };
    }
  ];

  den.aspects.battlenet.homeManager =
    { pkgs, host, ... }:
    let
      dir =
        if host.battlenet.dir == null then
          throw "battlenet: set den.hosts.<system>.${host.name}.battlenet.dir"
        else
          host.battlenet.dir;
    in
    {
      home.packages = [
        pkgs.umu-launcher
        (pkgs.writeShellScriptBin "battlenet" ''
          dir="$HOME/"${lib.escapeShellArg dir}
          exe="$dir/Battle.net Launcher.exe"

          if [ ! -f "$exe" ]; then
            echo "battlenet: $exe not found" >&2
            exit 1
          fi

          # The prefix is everything above drive_c
          export WINEPREFIX="''${dir%%/drive_c/*}"
          export PROTONPATH="${pkgs.proton-ge-bin.steamcompattool}"
          export GAMEID="umu-battlenet"

          exec umu-run "$exe" "$@"
        '')
      ];

      xdg.desktopEntries.battlenet = {
        name = "Battle.net";
        exec = "battlenet";
        categories = [ "Game" ];
      };
    };
}
