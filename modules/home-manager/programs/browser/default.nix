{
  config,
  lib,
  ...
}:
let
  cfg = config.userConfig.programs.browser;
in
{
  imports = [
    ./librewolf
  ];

  options.userConfig.programs.browser = {
    enable = lib.mkEnableOption "Browser";

    executable = lib.mkOption {
      type = lib.types.str;
      example = "librewolf";
      description = "Executable path";
    };

    desktop = lib.mkOption {
      type = lib.types.str;
      example = "librewolf.desktop";
      description = "Desktop application name";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.mimeApps.defaultApplications = {
      "text/html" = [ cfg.desktop ];
      "text/xml" = [ cfg.desktop ];
      "x-scheme-handle/http" = [ cfg.desktop ];
      "x-scheme-handle/https" = [ cfg.desktop ];
    };

    home.sessionVariables = {
      BROWSER = cfg.executable;
    };
  };
}
