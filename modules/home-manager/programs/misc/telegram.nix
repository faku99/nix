{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userConfig.programs.misc.telegram;
in
{
  options.userConfig.programs.misc.telegram = {
    enable = lib.mkEnableOption "Telegram Desktop";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      telegram-desktop
    ];
  };
}
