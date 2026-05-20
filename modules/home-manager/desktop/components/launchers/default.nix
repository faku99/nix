{
  lib,
  ...
}:
{
  imports = [
    ./rofi
  ];

  options.userConfig.desktop.components = {
    launcher = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "rofi" ]);
      default = null;
      example = "rofi";
      description = "Which desktop launcher to use";
    };
  };
}
