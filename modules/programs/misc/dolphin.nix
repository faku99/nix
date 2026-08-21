{
  den.aspects.dolphin.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs.kdePackages; [
        dolphin
        ark
        dolphin-plugins
        kdegraphics-thumbnailers
        libkdcraw
        kio
        kio-fuse
        kio-extras
        gwenview
      ];

      xdg.mimeApps.defaultApplications = {
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
}
