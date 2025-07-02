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
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji-wayland
        (mkIf (config.userConfig.programs.misc.rbw.enable) rofi-rbw-wayland)
      ];
    };
  };
}
