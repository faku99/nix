{
  den.aspects.rofi.homeManager =
    { config, lib, pkgs, ... }:
    {
      programs.rofi = {
        enable = true;
        plugins = with pkgs; [
          rofi-calc
          rofi-emoji
        ];
      };

      home.sessionVariables.DESKTOP_LAUNCHER = "${pkgs.rofi} -modes 'drun,calc,emoji' show 'drun'";

      home.packages = lib.optional config.programs.rbw.enable pkgs.rofi-rbw-wayland;
    };
}
