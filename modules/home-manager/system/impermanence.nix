{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.userConfig.system.impermanence;
in
{
  options.userConfig.system.impermanence = {
    enable = mkEnableOption "Impermanence";

    files = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [ ];
      description = "List of files stored persistently.";
    };

    directories = mkOption {
      type = types.listOf (types.either types.str types.attrs);
      default = [ ];
      description = "List of directories stored persistently.";
    };
  };

  config = mkIf cfg.enable {
    # TODO
  };
}
