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
    {
      pkgs,
      host,
      osConfig,
      ...
    }:
    let
      dir =
        if host.battlenet.dir == null then
          throw "battlenet: set den.hosts.<system>.${host.name}.battlenet.dir"
        else
          host.battlenet.dir;
    in
    {
      assertions = [
        {
          assertion = osConfig.programs.steam.enable;
          message = "battlenet runs on Steam's Proton Experimental, add den.aspects.steam to the host.";
        }
      ];

      home.packages = [
        pkgs.umu-launcher
        (pkgs.writeShellScriptBin "battlenet" ''
          dir="$HOME/"${lib.escapeShellArg dir}
          exe="$dir/Battle.net Launcher.exe"

          if [ ! -f "$exe" ]; then
            echo "battlenet: $exe not found" >&2
            exit 1
          fi

          # FIXME: switch back to pkgs.proton-ge-bin when WowB.exe survives its loader on GE-Proton
          export PROTONPATH="$HOME/.local/share/Steam/steamapps/common/Proton - Experimental"

          if [ ! -x "$PROTONPATH/proton" ]; then
            echo "battlenet: Proton Experimental not found at $PROTONPATH, install it in Steam" >&2
            exit 1
          fi

          # The prefix is everything above drive_c
          export WINEPREFIX="''${dir%%/drive_c/*}"
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
