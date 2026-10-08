{
  # See https://nixos.wiki/wiki/Thunar
  den.aspects.thunar = {
    nixos =
      { pkgs, ... }:
      {
        # Provides the xfconf dbus service, without it Thunar cannot persist settings
        programs.xfconf.enable = true;
        programs.thunar = {
          enable = true;
          plugins = with pkgs; [
            thunar-archive-plugin
            thunar-volman
            thunar-media-tags-plugin
          ];
        };
        services = {
          gvfs.enable = true;
          tumbler.enable = true;
        };
      };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          xarchiver
        ];

        # Scalable SVG theme, otherwise GTK falls back to low-res hicolor
        gtk.iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };

        xdg.mimeApps.defaultApplications = {
          "inode/directory" = "thunar.desktop";
        };
      };
  };
}
