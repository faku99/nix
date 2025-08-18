{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userConfig.programs.misc.claude-desktop;
in
{
  options.userConfig.programs.misc.claude-desktop = {
    enable = lib.mkEnableOption "claude-desktop";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with inputs.claude-desktop.packages.${pkgs.system}; [
      claude-desktop-with-fhs
    ];

    xdg.desktopEntries = {
      claude-desktop = {
        name = "Claude Desktop";
        exec = "claude-desktop";
        terminal = false;
        categories = [ "Application" ];
      };
    };

    userConfig.system.impermanence = {
      directories = [
        ".config/Claude"
      ];
    };
  };
}
