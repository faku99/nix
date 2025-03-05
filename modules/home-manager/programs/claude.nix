{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userConfig.programs.claude-desktop;
in
{
  options.userConfig.programs.claude-desktop = {
    enable = lib.mkEnableOption "claude-desktop";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with inputs.claude-desktop.packages.${pkgs.system}; [
      claude-desktop-with-fhs
    ];
  };
}
