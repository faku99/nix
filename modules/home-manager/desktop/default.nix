{
  config,
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

  home.sessionVariables = rec {
    XCURSOR_THEME = "Hackneyed";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = XCURSOR_THEME;
    HYPRCURSOR_SIZE = XCURSOR_SIZE;
  };

  assertions = [
    {
      assertion = cfg.shell != null -> cfg.components.bar == null && cfg.components.launcher == null;
      message = "Cannot use both shell and components simultaneously";
    }
  ];
}
