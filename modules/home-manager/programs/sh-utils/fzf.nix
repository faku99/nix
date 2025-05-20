{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.userConfig.programs.sh-utils.fzf;
in
{
  options.userConfig.programs.sh-utils.fzf = {
    enable = mkEnableOption "fzf";
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = if config.userConfig.shell.zsh.enable then true else false;

      defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
    };
  };
}
