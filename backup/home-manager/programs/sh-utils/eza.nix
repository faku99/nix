{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.sh-utils.eza;
in
{
  options.userConfig.programs.sh-utils.eza = {
    enable = mkEnableOption "eza";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      ls = "eza -l -g --git --group-directories-first";
    };
  };
}
