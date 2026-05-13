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
  cfg = config.userConfig.programs.terminal.alacritty;
in
{
  options.userConfig.programs.terminal.alacritty = {
    enable = mkEnableOption "alacritty";

    defaultTerminal = mkOption {
      type = types.bool;
      default = false;
      description = "Use alacritty as default terminal";
    };
  };

  config = mkIf cfg.enable {
    userConfig.programs.terminal = mkIf cfg.defaultTerminal {
      enable = true;
      executable = "${config.xdg.stateHome}/nix/profile/bin/alacritty";
    };

    programs.alacritty = {
      enable = true;
      settings = {
        keyboard.bindings = [
          {
            key = "Return";
            mods = "Shift | Super";
            action = "SpawnNewInstance";
          }
        ];
      };
    };
  };
}
