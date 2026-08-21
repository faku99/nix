# Shamelessly taken from https://github.com/uimataso/nix-config/blob/main/modules/home-manager/programs/sh-util/nix-helper.nix
{
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.userConfig.programs.sh-utils.nix-helper;

  homeDir = config.home.homeDirectory;
in {
  options.userConfig.programs.sh-utils.nix-helper = {
    enable = mkEnableOption ''
      Yet-another-nix-helper and other nix alias/scripts that improves QoL.
    '';

    flakeDir = mkOption {
      type = types.str;
      default = "${homeDir}/nix";
      description = "Root of your flake directory";
    };
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      no = "nh os switch ${cfg.flakeDir}";
      nu = "git -C ${cfg.flakeDir} pull && nh os switch ${cfg.flakeDir}";
      nt = "nh os test ${cfg.flakeDir}";
      nr = "nix repl --expr 'builtins.getFlake \"${cfg.flakeDir}\"'";
      nd = "nix develop path:$(pwd)";
    };

    programs.nh.enable = true;
  };
}
