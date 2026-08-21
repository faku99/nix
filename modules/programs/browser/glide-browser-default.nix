{ den, ... }:
{
  den.aspects.glide-browser-default = {
    includes = [ den.aspects.glide-browser ];

    homeManager = {
      xdg.mimeApps.defaultApplications = {
        "text/html" = [ "glide-browser.desktop" ];
        "text/xml" = [ "glide-browser.desktop" ];
        "x-scheme-handle/http" = [ "glide-browser.desktop" ];
        "x-scheme-handle/https" = [ "glide-browser.desktop" ];
      };

      home.sessionVariables.BROWSER = "glide-browser";
    };
  };
}
