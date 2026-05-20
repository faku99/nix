{
  lib,
  ...
}:
{
  imports = [
    ./waybar
  ];

  options.userConfig.desktop.components = {
    bar = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "waybar" ]);
      default = null;
      example = "waybar";
      description = "Which desktop bar to use";
    };
  };
}
