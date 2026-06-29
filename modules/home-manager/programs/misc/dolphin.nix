{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.misc.dolphin;
in
{
  options.userConfig.programs.misc.dolphin = {
    enable = mkEnableOption "dolphin";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs.kdePackages; [
      dolphin
      # Extensions
      ark
      dolphin-plugins
      kdegraphics-thumbnailers
      libkdcraw
      # Needed to mount network shares
      kio
      kio-fuse
      kio-extras
    ];
  };
}
