{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.misc.opencode;
in
{
  options.userConfig.programs.misc.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      opencode
    ];

    xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      theme = "gruvbox";
    };

    userConfig.system.impermanence = {
      directories = [
        ".local/share/opencode"
      ];
    };
  };
}
