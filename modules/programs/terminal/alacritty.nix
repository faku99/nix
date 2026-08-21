{
  den.aspects.alacritty.homeManager =
    { config, lib, pkgs, ... }:
    {
      home.sessionVariables.TERMINAL = "${config.xdg.stateHome}/nix/profile/bin/alacritty";

      programs.alacritty = {
        enable = true;
        package = config.lib.nixGL.wrap pkgs.alacritty;
        settings = {
          keyboard.bindings = [
            {
              key = "Return";
              mods = "Shift | Super";
              action = "SpawnNewInstance";
            }
          ];
        }
        // lib.optionalAttrs config.programs.zsh.enable {
          terminal.shell = "${config.programs.zsh.package}/bin/zsh";
        };
      };
    };
}
