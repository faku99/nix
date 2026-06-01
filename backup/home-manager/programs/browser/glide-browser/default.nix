{
  config,
  lib,
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
    programs.glide-browser = {
      enable = true;

      # TODO: config
    };

    userConfig.programs.browser = lib.mkIf cfg.defaultBrowser {
      enable = true;
      executable = "glide-browser";
      desktop = "glide-browser.desktop";
    };
  };
}
