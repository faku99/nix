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
          projects = null;
          publicShare = null;
          templates = null;
          videos = null;
          documents = "${config.home.homeDirectory}/Documents";
          download = "${config.home.homeDirectory}/Downloads";
        };
      };

      nix.settings.use-xdg-base-directories = true;
    };
}
