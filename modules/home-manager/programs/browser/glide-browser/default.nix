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

    defaultBrowser = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Set glide-browser as default browser";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      glide-browser
    ];

    userConfig.programs.browser = lib.mkIf cfg.defaultBrowser {
      enable = true;
      executable = "librewolf";
      desktop = "librewolf.desktop";
    };

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
