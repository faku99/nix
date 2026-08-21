{ inputs, ... }:
{
  den.aspects.glide-browser.homeManager = {
    imports = [ inputs.glide-browser.homeModules.default ];

    programs.glide-browser.enable = true;
  };
}
