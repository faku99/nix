{
  config,
  lib,
  ...
}:
let
  cfg = config.userConfig.global;
in
{
  options.userConfig.global = {
    enable = lib.mkEnableOption "Global settings";
    nixConfigDirectory = lib.mkOption {
      type = lib.types.path;
      default = "${config.home.homeDirectory}/nixos";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO 
  };
}