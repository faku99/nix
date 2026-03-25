{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userConfig.programs.browser.glide-browser;
in
{
  options.userConfig.programs.browser.glide-browser = {
    enable = lib.mkEnableOption "glide-browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      glide-browser
    ];

    xdg.desktopEntries = {
      glide-browser = {
        name = "glide";
        genericName = "Browser App";
        exec = "${pkgs.glide-browser}/bin/glide";
        icon = "glide";
        terminal = false;
        startupNotify = true;
      };
    };
  };
}
