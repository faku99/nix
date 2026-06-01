{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.userConfig.programs.terminal;
in
{
  imports = [
    ./alacritty.nix
  ];

  options.userConfig.programs.terminal = {
    enable = mkEnableOption "Terminal";

    executable = mkOption {
      type = types.str;
      description = "Executable path";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      TERMINAL = cfg.executable;
    };
  };
}
