{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.work;
in
{
  options.userConfig.programs.work = {
    enable = mkEnableOption "Work apps";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      prospect-mail
      teams-for-linux
    ];
  };
}
