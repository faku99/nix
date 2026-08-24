{
  # See https://nixos.wiki/wiki/Thunar
  den.aspects.thunar = {
    nixos = {
      services = {
          gvfs.enable = true;
          tumbler.enable = true;
      };
    };

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          thunar
          thunar-archive-plugin
          thunar-volman
          thunar-media-tags-plugin
          tumbler
          xarchiver
          xfconf
        ];

        xdg.mimeApps.defaultApplications = {
          "inode/directory" = "thunar.desktop";
        };
      };
  };
}
