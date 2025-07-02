{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.misc.rbw;
in
{
  options.userConfig.programs.misc.rbw = {
    enable = mkEnableOption "rbw";
  };

  config = mkIf cfg.enable {
    programs.rbw = {
      enable = true;
    };

    # pinentry-tty is needed for login
    home.packages = with pkgs; [
      pinentry-tty
    ];

    sops.secrets."rbw/config_json" = {
      path = "${config.home.homeDirectory}/.config/rbw/config.json";
      mode = "0600";
    };

    userConfig.system.impermanence = {
      directories = [
        ".cache/rbw"
      ];
    };
  };
}
