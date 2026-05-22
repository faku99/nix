{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.desktop.wayland.rofi;
in
{
  options.userConfig.desktop.wayland.rofi = {
    enable = mkEnableOption "rofi-wayland";
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji
      ];
    };

    home.sessionVariables = {
      DESKTOP_LAUNCHER = "${pkgs.rofi} -modes 'drun,calc,emoji' show 'drun'";
    };

    home.packages = mkIf config.userConfig.programs.misc.rbw.enable [
      pkgs.rofi-rbw-wayland
    ];
  };
}
