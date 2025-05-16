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

    home.packages = with pkgs; [
      flameshot # Screenshot program
      grim # Screenshots
      libnotify # Notifications
      loupe # Image viewer
      nemo # File explorer
      networkmanagerapplet
      swaynotificationcenter
      wl-clipboard # Clipboard support
    ];

    services.gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };
}
