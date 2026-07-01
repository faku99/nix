{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userConfig.desktop;
in
{
  imports = [
    ./components
    ./shells
    ./window-managers
  ];

  options.userConfig.desktop = {
    enable = lib.mkEnableOption "desktop environment";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      grim # Screenshots
      libnotify # Notifications
      loupe # Image viewer
      nemo-with-extensions # File explorer
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

    gtk = {
      enable = true;
      iconTheme = {
        name = "Gruvbox-Plus-Dark";
        package = pkgs.gruvbox-plus-icons;
      };
      cursorTheme = {
        name = "Hackneyed";
        package = pkgs.hackneyed;
      };
    };

    assertions = [
      {
        assertion = cfg.shell != null -> cfg.components.bar == null && cfg.components.launcher == null;
        message = "Cannot use both shell and components simultaneously";
      }
    ];
  };
}
