{
  lib,
  ...
}:
{
  imports = [
    ./noctalia
  ];

  options.userConfig.desktop = {
    shell = lib.mkOption {
      type = with lib.types; nullOr (enum [ "noctalia" ]);
      default = null;
      example = "noctalia";
      description = "Which desktop shell to use";
    };
  };
}
