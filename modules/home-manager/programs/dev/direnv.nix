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
  cfg = config.userConfig.programs.dev.direnv;
in
{
  options.userConfig.programs.dev.direnv = {
    enable = mkEnableOption "direnv";

    whitelist = mkOption {
      type = types.attrs;
      default = {
        prefix = [ "~/sources" ];
        exact = [ "~/nix" ];
      };
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      DIRENV_LOG_FORMAT = "";
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      config.whitelist = cfg.whitelist;
    };
  };
}
