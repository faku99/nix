{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.browser.brave;
in
{
  options.userConfig.programs.browser.brave = {
    enable = mkEnableOption "brave";
  };

  config = mkIf cfg.enable {
    programs.brave = {
      enable = true;
    };
  };
}
