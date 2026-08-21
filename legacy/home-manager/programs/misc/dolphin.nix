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
      gwenview # Image viewer
    ];

    xdg = {
      mimeApps.defaultApplications = {
        "image/bmp" = "org.kde.gwenview.desktop";
        "image/x-canon-cr3" = "org.kde.gwenview.desktop";
        "image/gif" = "org.kde.gwenview.desktop";
        "image/jpeg" = "org.kde.gwenview.desktop";
        "image/jp2" = "org.kde.gwenview.desktop";
        "image/jpeg2000" = "org.kde.gwenview.desktop";
        "image/jpx" = "org.kde.gwenview.desktop";
        "image/png" = "org.kde.gwenview.desktop";
        "image/svg" = "org.kde.gwenview.desktop";
        "image/tiff" = "org.kde.gwenview.desktop";
      };
    };
  };
}
