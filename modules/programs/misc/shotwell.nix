{
  den.aspects.shotwell.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.shotwell ];

      xdg.mimeApps.defaultApplications = {
        "image/bmp" = "org.gnome.Shotwell-Viewer.desktop";
        "image/x-bmp" = "org.gnome.Shotwell-Viewer.desktop";
        "image/gif" = "org.gnome.Shotwell-Viewer.desktop";
        "image/jpeg" = "org.gnome.Shotwell-Viewer.desktop";
        "image/png" = "org.gnome.Shotwell-Viewer.desktop";
        "image/tiff" = "org.gnome.Shotwell-Viewer.desktop";
        "image/webp" = "org.gnome.Shotwell-Viewer.desktop";
        "image/avif" = "org.gnome.Shotwell-Viewer.desktop";
        "image/heif" = "org.gnome.Shotwell-Viewer.desktop";
        "image/jxl" = "org.gnome.Shotwell-Viewer.desktop";
        "image/x-canon-cr3" = "org.gnome.Shotwell-Viewer.desktop";
      };
    };
}
