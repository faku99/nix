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
      type = with lib.types; nullOr (enum [ "rofi" ]);
      default = null;
      example = "rofi";
      description = "Which desktop launcher to use";
    };
  };
}
