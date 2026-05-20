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
      type = lib.types.enum [ "noctalia" ];
      default = null;
      example = "noctalia";
      description = "Which desktop shell to use";
    };
  };
}
