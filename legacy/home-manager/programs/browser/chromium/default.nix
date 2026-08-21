{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.browser.chromium;
in
{
  options.userConfig.programs.browser.chromium = {
    enable = mkEnableOption "chromium";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
  };
}
