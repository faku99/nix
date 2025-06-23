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

    userConfig.system.impermanence = {
      directories = [
        ".config/Claude"
      ];
    };
  };
}
