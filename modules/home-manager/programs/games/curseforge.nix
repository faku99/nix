{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.games.curseforge;
in {
  options.userConfig.programs.games.curseforge = {
    enable = mkEnableOption "curseforge";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      curseforge
    ];
  };
}
