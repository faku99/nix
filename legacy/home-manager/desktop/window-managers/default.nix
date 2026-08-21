{
  lib,
  ...
}:
{
  imports = [
    ./hyprland
  ];

  options.userConfig.desktop = {
    windowManager = lib.mkOption {
      type = with lib.types; nullOr (enum [ "hyprland" ]);
      default = null;
      example = "hyprland";
      description = "Window manager to use";
    };
  };
}
