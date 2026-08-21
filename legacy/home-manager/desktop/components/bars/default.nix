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
      type = with lib.types; nullOr (enum [ "waybar" ]);
      default = null;
      example = "waybar";
      description = "Which desktop bar to use";
    };
  };
}
