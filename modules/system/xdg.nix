{
  den.aspects.xdg.homeManager =
    { config, ... }:
    {
      xdg = {
        enable = true;
        mimeApps.enable = true;

        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = null;
          music = null;
          pictures = null;
          publicShare = null;
          templates = null;
          videos = null;
          documents = "${config.home.homeDirectory}/documents";
          download = "${config.home.homeDirectory}/downloads";
        };
      };

      nix.settings.use-xdg-base-directories = true;
    };
}
