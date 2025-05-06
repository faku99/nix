{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.userConfig.desktop.wayland;
in
{
  imports = [
    ./hyprland
    ./rofi
    ./waybar
  ];

  options.userConfig.desktop.wayland = {
    enable = mkEnableOption "wayland";
  };

  config = mkIf cfg.enable {
    userConfig.desktop.wayland = {
      # Enable wayland-specific configuration
      hyprland.enable = mkDefault true;
      rofi.enable = mkDefault true;
      waybar.enable = mkDefault true;
    };
  };
}
