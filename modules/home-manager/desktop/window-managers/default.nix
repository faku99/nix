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
      type = lib.types.nullOr (lib.types.enum [ "hyprland" ]);
      default = null;
      example = "hyprland";
      description = "Window manager to use";
    };
  };
}
