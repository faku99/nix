{
  myConfig.xdg = {
    homeManager =
      { config, ... }:
      {
        xdg = {
          enable = true;
          userDirs = {
            enable = true;
            createDirectories = true;
            setSessionVariables = true;
            desktop = null;
            templates = null;
            music = null;
            publicShare = null;
            projects = "${config.home.homeDirectory}/projects";
          };
        };
        home.sessionVariables = {
          CARGO_HOME = "${config.xdg.dataHome}/cargo";
        };
      };
  };
}
