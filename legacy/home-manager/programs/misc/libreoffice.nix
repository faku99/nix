{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.misc.libreoffice;
in
{
  options.userConfig.programs.misc.libreoffice = {
    enable = mkEnableOption "libreoffice";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice-qt6-fresh
    ];
  };
}
