{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.browser.qutebrowser;
in
{
  options.userConfig.programs.browser.qutebrowser = {
    enable = mkEnableOption "qutebrowser";
  };

  config = mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
    };
  };
}
