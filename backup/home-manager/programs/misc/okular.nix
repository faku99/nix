{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.misc.okular;
in
{
  options.userConfig.programs.misc.okular = {
    enable = mkEnableOption "okular";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.okular
    ];
  };
}
