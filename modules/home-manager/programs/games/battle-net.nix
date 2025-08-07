{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.games.battle-net;

  winePkg = pkgs.wine-staging;

  wowSharedPath = "${config.home.homeDirectory}/.wineprograms/World of Warcraft";

  bnetSharedPath = "${config.home.homeDirectory}/.wineprograms/Battle.net";
  bnetWinePrefix = "${config.home.homeDirectory}/.wineprefixes/battlenet";
  bnetWowPath = "${bnetWinePrefix}/drive_c/Program Files (x86)/World of Warcraft";
  bnetPath = "${bnetWinePrefix}/drive_c/Program Files (x86)/Battle.net";

  bnetWineWrapper = (pkgs.writeShellScriptBin "battlenet-wine-wrapper" ''
    set -e
    export WINEARCH=win64
    export WINEESYNC=1
    export WINEPREFIX="${bnetWinePrefix}"
    ${pkgs.winetricks}/bin/winetricks dxvk
    ${pkgs.winetricks}/bin/winetricks corefonts
    mkdir -p "${bnetSharedPath}"
    mkdir -p "${wowSharedPath}"
    mkdir -p "$( dirname "${bnetPath}" )"
    mkdir -p "$( dirname "${bnetWowPath}" )"
    ln -sfn "${bnetSharedPath}" "${bnetPath}"
    ln -sfn "${wowSharedPath}" "${bnetWowPath}"
    exec "$@"
  '');

  battlenet = pkgs.writeShellScriptBin "battlenet" ''
    ${bnetWineWrapper}/bin/battlenet-wine-wrapper ${winePkg}/bin/wine64 "${bnetPath}/Battle.net.exe"
  '';

  battlenet-setup = pkgs.writeShellScriptBin "battlenet-setup" ''
    bnet_setup=$( mktemp --tmpdir Battle.net-Setup.XXXXXXXXXX.exe )
    ${pkgs.wget}/bin/wget -O "$bnet_setup" 'https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe'
    ${bnetWineWrapper}/bin/battlenet-wine-wrapper ${winePkg}/bin/wine64 "$bnet_setup"
  '';
in
{
  options.userConfig.programs.games.battle-net = {
    enable = mkEnableOption "battle.net";
  };

  config = mkIf cfg.enable {
    home.packages = [
      battlenet
      battlenet-setup
    ];

    assertions = [
      {
        assertion = (osConfig.nixosConfig.programs.wine.enable == true);
        message = "Wine must be enabled in the NixOS configuration to install Battle.net";
      }
    ];
  };
}
