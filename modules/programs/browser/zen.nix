{ den, inputs, ... }:
{
  den.aspects.zen.homeManager =
    {
      imports = [ inputs.zen-browser.homeModules.default ];

      programs.zen-browser.enable = true;

      stylix.targets.zen-browser = {
        # Disable stylix for Zen
        enable = false;
        # Silence warning
        profileNames = [ "default" ];
      };
    };

  den.aspects.zen-default = {
    includes = [ den.aspects.zen ];

    homeManager.programs.zen-browser.setAsDefaultBrowser = true;
  };
}
